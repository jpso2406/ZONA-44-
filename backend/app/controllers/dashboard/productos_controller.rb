class Dashboard::ProductosController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!


  # GET /productos or /productos.json
  def index
    @productos = Producto.all.order(:id)
  end
  def edit
    @producto = Producto.find(params[:id])
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
      redirect_to productos_path, notice: "Producto creado con éxito"
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
