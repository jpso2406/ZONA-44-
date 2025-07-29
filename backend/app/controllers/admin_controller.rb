class AdminController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def dashboard
    @grupos = Grupo.all
    if params[:grupo_id].present?
      @productos = Producto.where(grupo_id: params[:grupo_id])
    else
      @productos = Producto.all
    end
  end
end
