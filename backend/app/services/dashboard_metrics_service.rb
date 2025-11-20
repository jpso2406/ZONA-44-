# frozen_string_literal: true

class DashboardMetricsService
  attr_reader :start_date, :end_date

  def initialize(start_date: 30.days.ago, end_date: Time.current)
    @start_date = start_date
    @end_date = end_date
  end

  # Métricas generales
  def overview_metrics
    {
      total_orders: total_orders,
      total_revenue: total_revenue,
      average_order_value: average_order_value,
      growth_rate: growth_rate,
      conversion_rate: conversion_rate,
      customer_retention: customer_retention_rate
    }
  end

  # Distribución de pedidos por estado
  def orders_by_status
    Order.where(created_at: start_date..end_date)
         .group(:status)
         .count
         .transform_keys { |k| k || "unknown" }
  end

  # Top productos
  def top_products(limit: 10)
    OrderItem.joins(:producto, :order)
             .where(orders: { created_at: start_date..end_date, status: [ "paid", "processing" ] })
             .group("productos.id, productos.name")
             .select("productos.id, productos.name,
                     SUM(order_items.quantity) as total_quantity,
                     SUM(order_items.total_price) as total_revenue")
             .order("total_revenue DESC")
             .limit(limit)
             .map do |item|
      {
        id: item.id,
        name: item.name,
        quantity: item.total_quantity,
        revenue: item.total_revenue.to_f.round(2)
      }
    end
  end

  # Ventas por categoría
  def sales_by_category
    OrderItem.joins(producto: :grupo)
             .joins(:order)
             .where(orders: { created_at: start_date..end_date, status: [ "paid", "processing" ] })
             .group("grupos.id, grupos.name")
             .select("grupos.name as category, SUM(order_items.total_price) as revenue")
             .order("revenue DESC")
             .map do |item|
      {
        category: item.category,
        revenue: item.revenue.to_f.round(2)
      }
    end
  end

  # Tendencia de ingresos
  def revenue_trend(group_by: :day)
    orders_scope = Order.where(created_at: start_date..end_date)
                       .where(status: [ "paid", "processing" ])

    case group_by
    when :hour
      orders_scope.group("DATE_TRUNC('hour', created_at)")
    when :day
      orders_scope.group("DATE_TRUNC('day', created_at)")
    when :week
      orders_scope.group("DATE_TRUNC('week', created_at)")
    when :month
      orders_scope.group("DATE_TRUNC('month', created_at)")
    else
      orders_scope.group("DATE_TRUNC('day', created_at)")
    end
      .sum(:total_amount)
      .map { |date, amount| { date: date, amount: amount.to_f.round(2) } }
      .sort_by { |h| h[:date] }
  end

  # Horas pico
  def peak_hours
    Order.where(created_at: start_date..end_date)
         .group("EXTRACT(HOUR FROM created_at)")
         .count
         .sort_by { |_hour, count| -count }
         .first(5)
         .map { |hour, count| { hour: hour.to_i, orders: count } }
  end

  # Días más ocupados
  def busiest_days
    Order.where(created_at: start_date..end_date)
         .group("EXTRACT(DOW FROM created_at)")
         .count
         .sort_by { |_day, count| -count }
         .map do |dow, count|
      {
        day_of_week: dow.to_i,
        day_name: Date::DAYNAMES[dow.to_i],
        orders: count
      }
    end
  end

  # Clientes top
  def top_customers(limit: 10)
    User.joins(:orders)
        .where(orders: { created_at: start_date..end_date, status: [ "paid", "processing" ] })
        .group("users.id, users.email, users.first_name, users.last_name")
        .select("users.id, users.email, users.first_name, users.last_name,
                SUM(orders.total_amount) as total_spent,
                COUNT(orders.id) as order_count")
        .order("total_spent DESC")
        .limit(limit)
        .map do |user|
      {
        id: user.id,
        name: "#{user.first_name} #{user.last_name}".strip,
        email: user.email,
        total_spent: user.total_spent.to_f.round(2),
        order_count: user.order_count
      }
    end
  end

  # Distribución por tipo de entrega
  def delivery_distribution
    Order.where(created_at: start_date..end_date)
         .group(:delivery_type)
         .select("delivery_type,
                 COUNT(*) as count,
                 SUM(total_amount) as revenue")
         .map do |result|
      {
        type: result.delivery_type || "unknown",
        count: result.count,
        revenue: result.revenue.to_f.round(2)
      }
    end
  end

  # Métodos de pago
  def payment_methods_distribution
    Order.where(created_at: start_date..end_date)
         .where(status: [ "paid", "processing" ])
         .group(:payment_method)
         .count
         .transform_keys { |k| k || "unknown" }
  end

  private

  def total_orders
    Order.where(created_at: start_date..end_date).count
  end

  def total_revenue
    Order.where(created_at: start_date..end_date)
         .where(status: [ "paid", "processing" ])
         .sum(:total_amount)
         .to_f
         .round(2)
  end

  def average_order_value
    return 0 if total_orders.zero?

    (total_revenue / total_orders).round(2)
  end

  def growth_rate
    current_revenue = total_revenue

    previous_period_start = start_date - (end_date - start_date)
    previous_period_end = start_date

    previous_revenue = Order.where(created_at: previous_period_start..previous_period_end)
                           .where(status: [ "paid", "processing" ])
                           .sum(:total_amount)
                           .to_f

    return 0 if previous_revenue.zero?

    (((current_revenue - previous_revenue) / previous_revenue) * 100).round(2)
  end

  def conversion_rate
    total = Order.where(created_at: start_date..end_date).count
    return 0 if total.zero?

    completed = Order.where(created_at: start_date..end_date, status: "paid").count

    ((completed.to_f / total) * 100).round(2)
  end

  def customer_retention_rate
    returning_customers = User.joins(:orders)
                              .where(orders: { created_at: start_date..end_date })
                              .group("users.id")
                              .having("COUNT(orders.id) > 1")
                              .count
                              .keys
                              .count

    total_customers = User.joins(:orders)
                          .where(orders: { created_at: start_date..end_date })
                          .distinct
                          .count

    return 0 if total_customers.zero?

    ((returning_customers.to_f / total_customers) * 100).round(2)
  end
end
