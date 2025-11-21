module Api
  module V1
    class AdminDashboardController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :authenticate_admin!

      # GET /api/v1/admin/dashboard
      def index
        @period = params[:period] || "30d"
        @compare = params[:compare] == "true"

        render json: build_dashboard_data, status: :ok
      rescue StandardError => e
        Rails.logger.error("[AdminDashboardController#index] Error: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        render json: {
          success: false,
          error: "Error al cargar el dashboard",
          message: e.message
        }, status: :internal_server_error
      end

      # GET /api/v1/admin/dashboard/analytics
      def analytics
        @start_date = parse_date(params[:start_date]) || 30.days.ago
        @end_date = parse_date(params[:end_date]) || Time.current

        render json: {
          success: true,
          data: {
            sales_analytics: sales_analytics,
            customer_analytics: customer_analytics,
            product_analytics: product_analytics,
            time_analytics: time_analytics
          },
          meta: {
            start_date: @start_date,
            end_date: @end_date,
            generated_at: Time.current
          }
        }, status: :ok
      rescue StandardError => e
        Rails.logger.error("[AdminDashboardController#analytics] Error: #{e.message}")
        render json: { success: false, error: e.message }, status: :internal_server_error
      end

      # GET /api/v1/admin/dashboard/realtime
      def realtime
        render json: {
          success: true,
          data: {
            active_orders: active_orders_count,
            online_users: online_users_estimate,
            pending_alerts: pending_alerts,
            system_health: system_health_check,
            recent_activity: recent_activity_feed
          },
          timestamp: Time.current
        }, status: :ok
      rescue StandardError => e
        render json: { success: false, error: e.message }, status: :internal_server_error
      end

      # GET /api/v1/admin/dashboard/daily_sales
      def daily_sales
        @start_date = parse_date(params[:start_date]) || 30.days.ago
        @end_date = parse_date(params[:end_date]) || Time.current
        @group_by = params[:group_by] || "day" # day, week, month

        render json: {
          success: true,
          data: {
            sales_by_period: detailed_sales_by_period,
            summary: {
              total_revenue: calculate_total_revenue(@start_date, @end_date),
              total_orders: calculate_total_orders(@start_date, @end_date),
              average_daily_revenue: calculate_avg_daily_revenue(@start_date, @end_date),
              best_day: find_best_day(@start_date, @end_date),
              worst_day: find_worst_day(@start_date, @end_date)
            },
            comparison: {
              vs_previous_period: compare_with_previous_period(@start_date, @end_date)
            }
          },
          meta: {
            start_date: @start_date,
            end_date: @end_date,
            group_by: @group_by,
            days_count: (@end_date.to_date - @start_date.to_date).to_i + 1
          }
        }, status: :ok
      rescue StandardError => e
        Rails.logger.error("[AdminDashboardController#daily_sales] Error: #{e.message}")
        render json: { success: false, error: e.message }, status: :internal_server_error
      end

      private

      def build_dashboard_data
        date_range = calculate_date_range(@period)
        current_data = fetch_period_data(date_range[:start], date_range[:end])

        response = {
          success: true,
          data: {
            overview: overview_statistics(current_data),
            charts: {
              revenue_trend: revenue_trend_data(date_range),
              orders_by_status: orders_by_status_data,
              top_products: top_products_data,
              sales_by_category: sales_by_category_data,
              delivery_type_distribution: delivery_type_distribution
            },
            recent_orders: recent_orders_data,
            performance_metrics: performance_metrics,
            alerts: system_alerts
          },
          meta: {
            period: @period,
            generated_at: Time.current,
            cache_expires_in: 5.minutes.from_now
          }
        }

        if @compare
          previous_data = fetch_period_data(date_range[:compare_start], date_range[:compare_end])
          response[:data][:comparison] = comparison_data(current_data, previous_data)
        end

        response
      end

      def overview_statistics(data)
        total_orders = data[:orders].count
        total_revenue = data[:orders].where(status: [ "paid", "processing" ]).sum(:total_amount).to_f
        avg_order_value = total_orders > 0 ? (total_revenue / total_orders).round(2) : 0

        {
          total_orders: total_orders,
          total_revenue: total_revenue.round(2),
          average_order_value: avg_order_value,
          pending_orders: data[:orders].where(status: "pending").count,
          processing_orders: data[:orders].where(status: "processing").count,
          completed_orders: data[:orders].where(status: "paid").count,
          failed_orders: data[:orders].where(status: "failed").count,
          cancelled_orders: data[:orders].where(status: "cancelled").count,
          conversion_rate: calculate_conversion_rate(data),
          customer_retention_rate: calculate_retention_rate(data)
        }
      end

      def revenue_trend_data(date_range)
        orders = Order.where(created_at: date_range[:start]..date_range[:end])
                     .where(status: [ "paid", "processing" ])

        group_by = determine_grouping(@period)

        case group_by
        when "day"
          orders.group("DATE(created_at)")
                .select("DATE(created_at) as period,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value")
                .order("period ASC")
        when "week"
          orders.group("DATE_TRUNC('week', created_at)")
                .select("DATE_TRUNC('week', created_at) as period,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value")
                .order("period ASC")
        when "month"
          orders.group("DATE_TRUNC('month', created_at)")
                .select("DATE_TRUNC('month', created_at) as period,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value")
                .order("period ASC")
        else
          orders.group("DATE(created_at)")
                .select("DATE(created_at) as period,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value")
                .order("period ASC")
        end.map do |result|
          {
            period: format_period(result.period, group_by),
            revenue: result.revenue.to_f.round(2),
            order_count: result.order_count,
            avg_order_value: result.avg_order_value.to_f.round(2)
          }
        end
      end

      def orders_by_status_data
        statuses = %w[pending processing paid failed cancelled]
        total_orders = Order.count
        total_orders = 1 if total_orders.zero? # Evitar división por cero

        statuses.map do |status|
          count = Order.where(status: status).count
          {
            status: status,
            count: count,
            label: I18n.t("order.status.#{status}", default: status.humanize),
            percentage: (count.to_f / total_orders * 100).round(1)
          }
        end
      end

      def top_products_data
        OrderItem.joins(:producto)
                 .select("productos.name,
                         SUM(order_items.quantity) as total_quantity,
                         SUM(order_items.total_price) as total_revenue,
                         COUNT(DISTINCT order_items.order_id) as order_count")
                 .group("productos.id, productos.name")
                 .order("total_revenue DESC")
                 .limit(10)
                 .map do |item|
          {
            name: item.name,
            quantity_sold: item.total_quantity,
            revenue: item.total_revenue.to_f.round(2),
            order_count: item.order_count
          }
        end
      end

      def sales_by_category_data
        OrderItem.joins(producto: :grupo)
                 .select("grupos.nombre as category,
                         SUM(order_items.total_price) as revenue,
                         COUNT(order_items.id) as item_count")
                 .group("grupos.id, grupos.nombre")
                 .order("revenue DESC")
                 .map do |item|
          {
            category: item.category,
            revenue: item.revenue.to_f.round(2),
            item_count: item.item_count
          }
        end
      end

      def delivery_type_distribution
        Order.group(:delivery_type)
             .select("delivery_type,
                     COUNT(*) as count,
                     SUM(total_amount) as revenue,
                     AVG(total_amount) as avg_value")
             .map do |result|
          {
            type: result.delivery_type || "unknown",
            count: result.count,
            revenue: result.revenue.to_f.round(2),
            avg_value: result.avg_value.to_f.round(2)
          }
        end
      end

      def recent_orders_data
        Order.includes(:user, order_items: :producto)
             .order(created_at: :desc)
             .limit(15)
             .map do |order|
          {
            id: order.id,
            order_number: order.order_number,
            customer_name: order.customer_name,
            customer_email: order.customer_email,
            customer_phone: order.customer_phone,
            total_amount: order.total_amount.to_f,
            status: order.status,
            delivery_type: order.delivery_type,
            payment_method: order.payment_method,
            created_at: order.created_at.iso8601,
            items_count: order.order_items.count,
            user_id: order.user_id
          }
        end
      end

      def performance_metrics
        {
          avg_order_processing_time: calculate_avg_processing_time,
          order_fulfillment_rate: calculate_fulfillment_rate,
          revenue_growth: calculate_revenue_growth,
          customer_satisfaction_score: calculate_satisfaction_score,
          peak_hours: calculate_peak_hours,
          busiest_days: calculate_busiest_days
        }
      end

      def system_alerts
        alerts = []

        # Alert por pedidos pendientes antiguos
        old_pending = Order.where(status: "pending")
                          .where("created_at < ?", 1.hour.ago)
                          .count

        if old_pending > 0
          alerts << {
            type: "warning",
            severity: "medium",
            message: "#{old_pending} pedidos pendientes con más de 1 hora",
            action: "review_pending_orders"
          }
        end

        # Alert por pedidos fallidos hoy
        failed_today = Order.where(status: "failed")
                           .where("created_at >= ?", Time.current.beginning_of_day)
                           .count

        if failed_today > 5
          alerts << {
            type: "error",
            severity: "high",
            message: "#{failed_today} pedidos fallidos hoy. Revisar pasarela de pago",
            action: "check_payment_gateway"
          }
        end

        # Alert por bajo inventario (si aplica)
        # Aquí puedes agregar lógica de inventario si la tienes

        alerts
      end

      # Métodos auxiliares de cálculo

      def calculate_date_range(period)
        end_date = Time.current

        case period
        when "7d"
          start_date = 7.days.ago
          compare_start = 14.days.ago
          compare_end = 7.days.ago
        when "30d"
          start_date = 30.days.ago
          compare_start = 60.days.ago
          compare_end = 30.days.ago
        when "90d"
          start_date = 90.days.ago
          compare_start = 180.days.ago
          compare_end = 90.days.ago
        when "1y"
          start_date = 1.year.ago
          compare_start = 2.years.ago
          compare_end = 1.year.ago
        else
          start_date = 30.days.ago
          compare_start = 60.days.ago
          compare_end = 30.days.ago
        end

        {
          start: start_date,
          end: end_date,
          compare_start: compare_start,
          compare_end: compare_end
        }
      end

      def fetch_period_data(start_date, end_date)
        {
          orders: Order.where(created_at: start_date..end_date),
          users: User.where(created_at: start_date..end_date)
        }
      end

      def determine_grouping(period)
        case period
        when "7d"
          "day"
        when "30d"
          "day"
        when "90d"
          "week"
        when "1y"
          "month"
        else
          "day"
        end
      end

      def format_period(date, grouping)
        return "" if date.nil?

        case grouping
        when "day"
          date.strftime("%Y-%m-%d")
        when "week"
          "Semana #{date.strftime('%U, %Y')}"
        when "month"
          date.strftime("%b %Y")
        else
          date.to_s
        end
      end

      def comparison_data(current, previous)
        current_revenue = current[:orders].where(status: [ "paid", "processing" ]).sum(:total_amount).to_f
        previous_revenue = previous[:orders].where(status: [ "paid", "processing" ]).sum(:total_amount).to_f

        revenue_change = previous_revenue > 0 ?
          ((current_revenue - previous_revenue) / previous_revenue * 100).round(2) : 0

        current_orders = current[:orders].count
        previous_orders = previous[:orders].count
        orders_change = previous_orders > 0 ?
          ((current_orders - previous_orders).to_f / previous_orders * 100).round(2) : 0

        {
          revenue_change: revenue_change,
          orders_change: orders_change,
          current_period: {
            revenue: current_revenue.round(2),
            orders: current_orders
          },
          previous_period: {
            revenue: previous_revenue.round(2),
            orders: previous_orders
          }
        }
      end

      def calculate_conversion_rate(data)
        # Lógica básica: órdenes completadas vs totales
        total = data[:orders].count
        completed = data[:orders].where(status: "paid").count

        total > 0 ? (completed.to_f / total * 100).round(2) : 0
      end

      def calculate_retention_rate(data)
        # Lógica básica: usuarios que han hecho más de un pedido
        returning_customers = User.joins(:orders)
                                  .group("users.id")
                                  .having("COUNT(orders.id) > 1")
                                  .count
                                  .keys
                                  .count

        total_customers = User.joins(:orders).distinct.count

        total_customers > 0 ? (returning_customers.to_f / total_customers * 100).round(2) : 0
      end

      def calculate_avg_processing_time
        # Tiempo promedio entre creación y completado
        completed_orders = Order.where(status: "paid")
                               .where("created_at >= ?", 30.days.ago)

        return 0 if completed_orders.empty?

        total_time = completed_orders.sum do |order|
          (order.updated_at - order.created_at) / 60 # en minutos
        end

        (total_time / completed_orders.count).round(2)
      end

      def calculate_fulfillment_rate
        total = Order.where("created_at >= ?", 30.days.ago).count
        return 0 if total.zero?

        fulfilled = Order.where("created_at >= ?", 30.days.ago)
                        .where(status: "paid")
                        .count

        (fulfilled.to_f / total * 100).round(2)
      end

      def calculate_revenue_growth
        current_month = Order.where(created_at: Time.current.beginning_of_month..Time.current)
                            .where(status: [ "paid", "processing" ])
                            .sum(:total_amount)

        last_month = Order.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
                         .where(status: [ "paid", "processing" ])
                         .sum(:total_amount)

        return 0 if last_month.zero?

        ((current_month - last_month) / last_month * 100).round(2)
      end

      def calculate_satisfaction_score
        # Placeholder - implementar si tienes sistema de calificaciones
        0
      end

      def calculate_peak_hours
        Order.where("created_at >= ?", 30.days.ago)
             .group("EXTRACT(HOUR FROM created_at)")
             .count
             .sort_by { |_hour, count| -count }
             .first(5)
             .map { |hour, count| { hour: hour.to_i, orders: count } }
      end

      def calculate_busiest_days
        Order.where("created_at >= ?", 30.days.ago)
             .group("TO_CHAR(created_at, 'Day')")
             .count
             .sort_by { |_day, count| -count }
             .map { |day, count| { day: day.strip, orders: count } }
      end

      # Analytics methods

      def sales_analytics
        {
          total_sales: Order.where(status: [ "paid", "processing" ]).sum(:total_amount).to_f,
          sales_by_hour: sales_by_hour_data,
          sales_by_day_of_week: sales_by_day_data,
          sales_forecast: calculate_sales_forecast
        }
      end

      def customer_analytics
        {
          total_customers: User.count,
          new_customers: User.where("created_at >= ?", @start_date).count,
          repeat_customers: calculate_repeat_customers,
          customer_lifetime_value: calculate_customer_ltv,
          top_customers: top_customers_data
        }
      end

      def product_analytics
        {
          total_products_sold: OrderItem.sum(:quantity),
          product_performance: product_performance_data,
          trending_products: trending_products_data
        }
      end

      def time_analytics
        {
          peak_ordering_times: calculate_peak_hours,
          average_order_time: calculate_avg_processing_time,
          time_to_completion: calculate_time_to_completion
        }
      end

      def sales_by_hour_data
        Order.where(created_at: @start_date..@end_date)
             .where(status: [ "paid", "processing" ])
             .group("EXTRACT(HOUR FROM created_at)")
             .sum(:total_amount)
             .map { |hour, amount| { hour: hour.to_i, revenue: amount.to_f.round(2) } }
             .sort_by { |h| h[:hour] }
      end

      def sales_by_day_data
        Order.where(created_at: @start_date..@end_date)
             .where(status: [ "paid", "processing" ])
             .group("EXTRACT(DOW FROM created_at)")
             .sum(:total_amount)
             .map { |dow, amount| { day: dow.to_i, revenue: amount.to_f.round(2) } }
             .sort_by { |d| d[:day] }
      end

      def calculate_sales_forecast
        # Pronóstico simple basado en tendencia lineal
        recent_sales = Order.where("created_at >= ?", 7.days.ago)
                           .where(status: [ "paid", "processing" ])
                           .group("DATE(created_at)")
                           .sum(:total_amount)

        return [] if recent_sales.empty?

        avg_daily_sales = recent_sales.values.sum / recent_sales.count

        7.times.map do |i|
          {
            date: (Time.current + i.days).to_date,
            forecast: (avg_daily_sales * (1 + rand(-0.1..0.1))).round(2)
          }
        end
      end

      def calculate_repeat_customers
        User.joins(:orders)
            .group("users.id")
            .having("COUNT(orders.id) > 1")
            .count
            .keys
            .count
      end

      def calculate_customer_ltv
        total_revenue = Order.where(status: [ "paid", "processing" ]).sum(:total_amount).to_f
        total_customers = User.joins(:orders).distinct.count

        total_customers > 0 ? (total_revenue / total_customers).round(2) : 0
      end

      def top_customers_data
        User.joins(:orders)
            .where(orders: { status: [ "paid", "processing" ] })
            .group("users.id, users.email, users.first_name, users.last_name")
            .select("users.id, users.email, users.first_name, users.last_name,
                    SUM(orders.total_amount) as total_spent,
                    COUNT(orders.id) as order_count")
            .order("total_spent DESC")
            .limit(10)
            .map do |user|
          {
            id: user.id,
            email: user.email,
            name: "#{user.first_name} #{user.last_name}".strip,
            total_spent: user.total_spent.to_f.round(2),
            order_count: user.order_count
          }
        end
      end

      def product_performance_data
        OrderItem.joins(:producto)
                 .select("productos.id, productos.name,
                         SUM(order_items.quantity) as quantity_sold,
                         SUM(order_items.total_price) as revenue,
                         AVG(order_items.unit_price) as avg_price")
                 .group("productos.id, productos.name")
                 .order("revenue DESC")
                 .limit(20)
                 .map do |item|
          {
            id: item.id,
            name: item.name,
            quantity_sold: item.quantity_sold,
            revenue: item.revenue.to_f.round(2),
            avg_price: item.avg_price.to_f.round(2)
          }
        end
      end

      def trending_products_data
        # Productos con mayor crecimiento en los últimos 7 días
        OrderItem.joins(:producto)
                 .where("order_items.created_at >= ?", 7.days.ago)
                 .group("productos.id, productos.name")
                 .select("productos.name,
                         SUM(order_items.quantity) as recent_sales")
                 .order("recent_sales DESC")
                 .limit(10)
                 .map do |item|
          {
            name: item.name,
            recent_sales: item.recent_sales,
            trend: "up"
          }
        end
      end

      def calculate_time_to_completion
        Order.where(status: "paid")
             .where("created_at >= ?", @start_date)
             .average("EXTRACT(EPOCH FROM (updated_at - created_at)) / 60")
             &.round(2) || 0
      end

      # Realtime methods

      def active_orders_count
        Order.where(status: [ "pending", "processing" ]).count
      end

      def online_users_estimate
        # Estimación basada en pedidos recientes
        Order.where("created_at >= ?", 15.minutes.ago).distinct.count(:customer_email)
      end

      def pending_alerts
        Order.where(status: "pending")
             .where("created_at < ?", 30.minutes.ago)
             .count
      end

      def system_health_check
        {
          database: "healthy",
          cache: "healthy",
          api: "healthy",
          payment_gateway: "healthy",
          status: "operational"
        }
      end

      def recent_activity_feed
        Order.order(created_at: :desc)
             .limit(20)
             .map do |order|
          {
            type: "order",
            action: "created",
            order_number: order.order_number,
            amount: order.total_amount.to_f,
            timestamp: order.created_at.iso8601
          }
        end
      end

      def parse_date(date_str)
        return nil if date_str.blank?

        Time.zone.parse(date_str)
      rescue ArgumentError
        nil
      end

      # Métodos para daily_sales endpoint

      def detailed_sales_by_period
        orders = Order.where(created_at: @start_date..@end_date)
                      .where(status: [ "paid", "processing" ])

        case @group_by
        when "day"
          orders.group("DATE(created_at)")
                .select("DATE(created_at) as date,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value,
                        MIN(total_amount) as min_order,
                        MAX(total_amount) as max_order,
                        COUNT(DISTINCT customer_email) as unique_customers")
                .order("date ASC")
        when "week"
          orders.group("DATE_TRUNC('week', created_at)")
                .select("DATE_TRUNC('week', created_at) as date,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value,
                        COUNT(DISTINCT customer_email) as unique_customers")
                .order("date ASC")
        when "month"
          orders.group("DATE_TRUNC('month', created_at)")
                .select("DATE_TRUNC('month', created_at) as date,
                        SUM(total_amount) as revenue,
                        COUNT(*) as order_count,
                        AVG(total_amount) as avg_order_value,
                        COUNT(DISTINCT customer_email) as unique_customers")
                .order("date ASC")
        end.map do |result|
          {
            date: result.date.strftime("%Y-%m-%d"),
            revenue: result.revenue.to_f.round(2),
            order_count: result.order_count,
            avg_order_value: result.avg_order_value.to_f.round(2),
            min_order: result.try(:min_order)&.to_f&.round(2),
            max_order: result.try(:max_order)&.to_f&.round(2),
            unique_customers: result.unique_customers,
            day_of_week: Date.parse(result.date.to_s).strftime("%A")
          }
        end
      end

      def calculate_total_revenue(start_date, end_date)
        Order.where(created_at: start_date..end_date)
             .where(status: [ "paid", "processing" ])
             .sum(:total_amount)
             .to_f
             .round(2)
      end

      def calculate_total_orders(start_date, end_date)
        Order.where(created_at: start_date..end_date)
             .where(status: [ "paid", "processing" ])
             .count
      end

      def calculate_avg_daily_revenue(start_date, end_date)
        total_revenue = calculate_total_revenue(start_date, end_date)
        days = (end_date.to_date - start_date.to_date).to_i + 1
        days > 0 ? (total_revenue / days).round(2) : 0
      end

      def find_best_day(start_date, end_date)
        best = Order.where(created_at: start_date..end_date)
                    .where(status: [ "paid", "processing" ])
                    .group("DATE(created_at)")
                    .select("DATE(created_at) as date, SUM(total_amount) as revenue")
                    .order("revenue DESC")
                    .first

        return nil unless best

        {
          date: best.date.strftime("%Y-%m-%d"),
          revenue: best.revenue.to_f.round(2),
          day_name: best.date.strftime("%A")
        }
      end

      def find_worst_day(start_date, end_date)
        worst = Order.where(created_at: start_date..end_date)
                     .where(status: [ "paid", "processing" ])
                     .group("DATE(created_at)")
                     .select("DATE(created_at) as date, SUM(total_amount) as revenue")
                     .order("revenue ASC")
                     .first

        return nil unless worst

        {
          date: worst.date.strftime("%Y-%m-%d"),
          revenue: worst.revenue.to_f.round(2),
          day_name: worst.date.strftime("%A")
        }
      end

      def compare_with_previous_period(start_date, end_date)
        current_revenue = calculate_total_revenue(start_date, end_date)
        current_orders = calculate_total_orders(start_date, end_date)

        days_diff = (end_date.to_date - start_date.to_date).to_i
        previous_start = start_date - days_diff.days
        previous_end = start_date - 1.day

        previous_revenue = calculate_total_revenue(previous_start, previous_end)
        previous_orders = calculate_total_orders(previous_start, previous_end)

        {
          current: {
            revenue: current_revenue,
            orders: current_orders
          },
          previous: {
            revenue: previous_revenue,
            orders: previous_orders
          },
          change: {
            revenue_percentage: previous_revenue > 0 ?
              (((current_revenue - previous_revenue) / previous_revenue) * 100).round(2) : 0,
            orders_percentage: previous_orders > 0 ?
              (((current_orders - previous_orders).to_f / previous_orders) * 100).round(2) : 0
          }
        }
      end

      def authenticate_admin!
        token = request.headers["Authorization"]&.gsub("Bearer ", "")

        unless token.present?
          render json: {
            success: false,
            error: "Token de autenticación no proporcionado"
          }, status: :unauthorized
          return
        end

        # Buscar admin por API token (usando :: para referenciar la clase Admin del modelo global)
        admin = ::Admin.find_by(api_token: token) if ::Admin.column_names.include?("api_token")

        # Alternativamente, buscar usuario con rol admin
        user = ::User.find_by(api_token: token) if admin.nil? && ::User.column_names.include?("api_token")

        unless admin || user&.admin?
          render json: {
            success: false,
            error: "No autorizado. Se requieren privilegios de administrador"
          }, status: :forbidden
          return
        end

        @current_admin = admin || user
      end
    end
  end
end
