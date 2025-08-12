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

  
end
