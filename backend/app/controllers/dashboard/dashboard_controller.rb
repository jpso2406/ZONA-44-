class Dashboard::DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!

  def after_sign_in_path_for(resource)
    dashboard_root_path
  end


  def index
    @total_grupos = Grupo.count
    @total_productos = Producto.count
    @total_promociones = Promocion.count
  end
  def index
    # Ventas por día
    ventas_por_dia = Order
      .group(Arel.sql("DATE(created_at)"))
      .order(Arel.sql("DATE(created_at) ASC"))
      .limit(7)
      .sum(:total_amount)

    @labels_dia = ventas_por_dia.keys.map { |d| d.strftime("%d-%m") }
    @data_dia   = ventas_por_dia.values

    # Ventas por mes
    ventas_por_mes = Order
      .group(Arel.sql("DATE_TRUNC('month', created_at)"))
      .order(Arel.sql("DATE_TRUNC('month', created_at) ASC"))
      .limit(12)
      .sum(:total_amount)

    @labels_mes = ventas_por_mes.keys.map { |d| d.strftime("%b %Y") }
    @data_mes   = ventas_por_mes.values

    # Ventas por año
    ventas_por_ano = Order
      .group(Arel.sql("DATE_TRUNC('year', created_at)"))
      .order(Arel.sql("DATE_TRUNC('year', created_at) ASC"))
      .sum(:total_amount)

    @labels_ano = ventas_por_ano.keys.map { |d| d.year.to_s }
    @data_ano   = ventas_por_ano.values

    # Productos más vendidos
    productos = OrderItem
      .joins(:producto)
      .group("productos.name")
      .order(Arel.sql("SUM(order_items.quantity) DESC"))
      .limit(5)
      .sum(:quantity)

    @labels_productos = productos.keys
    @data_productos   = productos.values
  end
end
