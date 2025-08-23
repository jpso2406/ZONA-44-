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
      # Productos más vendidos (Top 5)
      productos = OrderItem
      .joins(:producto)
      .group("productos.name")
      .order("SUM(order_items.quantity) DESC")
      .limit(5)
      .sum(:quantity)

        # Preparamos los datos para Chart.js
        @labels = productos.keys      # ["Pizza Especial", "Pizza Tradicional", ...]
        @data   = productos.values    # [35, 28, 20, ...]
    end
end
