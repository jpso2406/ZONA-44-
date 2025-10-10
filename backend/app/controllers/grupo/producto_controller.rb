class Grupo::ProductoController < ApplicationController 
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_grupo
  before_action :set_product, only: [:show]
  
  def index
    @productos = @grupo.productos
    
    # Para el menú lateral de grupos
    @grupos = Grupo.all.order(:id)

    # busqueda
    if params[:query].present?
      query = params[:query].downcase
      @productos = @productos.where("LOWER(name) LIKE ? OR LOWER(descripcion) LIKE ?", query, query)
    end

    # ✅ Guardar en la sesión el grupo actual para mostrar botón de "Volver al grupo" en el carrito
    session[:grupo_actual_id] = @grupo.id
    session[:grupo_actual_slug] = @grupo.slug


  end
  

  def show
    @producto = @grupo.productos.find(params[:id])
  end

  private

  def set_grupo
    @grupo = Grupo.find(params[:grupo_id])
  end

  def set_product
    @producto = @grupo.productos.find(params[:id])
  end
end
