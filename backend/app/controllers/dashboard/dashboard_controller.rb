class Dashboard::DashboardController < ApplicationController
  layout "dashboard"

  # 🔒 Solo usuarios autenticados
  before_action :authenticate_user!
  before_action :require_admin!

  # Redirección después de login
  # Esto puede ir también en ApplicationController
  def after_sign_in_path_for(resource)
  case resource.role
  when "admin"
    dashboard_root_path
  else
    root_path
  end
end

  # Dashboard principal
  def index
    # Totales
    @total_grupos = Grupo.count
    @total_productos = Producto.count
    @total_promociones = Promocion.count

    # Ventas por día (últimos 7 días)
    ventas_por_dia = Order
                      .group(Arel.sql("DATE(created_at)"))
                      .order(Arel.sql("DATE(created_at) ASC"))
                      .limit(7)
                      .sum(:total_amount)
    @labels_dia = ventas_por_dia.keys.map { |d| d.strftime("%d-%m") }
    @data_dia   = ventas_por_dia.values

    # Ventas por mes (últimos 12 meses)
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

  private

  # 🔑 Solo admin puede acceder al dashboard
  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "No tienes permisos para acceder al panel de administración"
    end
  end
end
