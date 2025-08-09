class Dashboard::ProductosController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!
  before_action :set_producto, only: [:edit, :update, :destroy, :show]



  # GET /productos or /productos.json
  def index
    @productos = Producto.all.order(:id)
    @grupos = if params[:grupo_id].present?
              Grupo.where(id: params[:grupo_id])
            else
              Grupo.includes(:productos)
            end
    @producto = Producto.new
  end
  def edit
    @producto = Producto.find(params[:id])

  end
 
  def destroy
    @producto = Producto.find(params[:id])
    if @producto.destroy
      redirect_to dashboard_productos_path, notice: "Producto eliminado correctamente"
    else
      redirect_to dashboard_productos_path, alert: "Error al eliminar el producto"
    end
  end
  def update
     @producto = Producto.find(params[:id])
    if @producto.update(producto_params)
      redirect_to dashboard_productos_path, notice: "Producto actualizado correctamente"
    else
      render :edit
    end
  end
  # GET /productos/1 or /productos/1.json
  def show
    @producto = Producto.find(params[:id])
    @producto = Producto.new
  end

  # GET /productos/new
  def new
    @producto = Producto.new
  end
  

  # POST /productos or /productos.json
  def create
    @producto = Producto.new(producto_params)
    if @producto.save
      redirect_to dashboard_productos_path, notice: "Producto creado con éxito"
    else
      render :new
    end
  end

  private

  def set_producto
    @producto = Producto.find(params[:id])
  end

  def producto_params
    params.require(:producto).permit(:nombre, :precio, :descripcion, :grupo_id)
  end
end
