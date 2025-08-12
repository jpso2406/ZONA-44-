class ProductosController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_producto, only: %i[ show edit update destroy ]

  # GET /productos or /productos.json
  def index
    if params[:grupo_id].present?
      @productos = Producto.where(grupo_id: params[:grupo_id])
      @pizzas_tradicionales = PizzaTradicional.where(grupo_id: params[:grupo_id])
      @pizzas_especiales = PizzaEspecial.where(grupo_id: params[:grupo_id])
    else
      @productos = Producto.all
      @pizzas_tradicionales = PizzaTradicional.all
      @pizzas_especiales = PizzaEspecial.all
    end

    respond_to do |format|
      format.html do
        if request.headers['Accept']&.include?('text/html') && request.headers['X-Requested-With'] != 'Turbo'
          render partial: "admin/productos_list", locals: { productos: @productos, pizzas_tradicionales: @pizzas_tradicionales, pizzas_especiales: @pizzas_especiales }, layout: false
        else
          head :no_content
        end
      end
      format.json { render json: @productos }
    end
  end



  # GET /productos/1 or /productos/1.json
  def show
  end

  # GET /productos/new
  def new
    @producto = Producto.new
    render partial: 'form', locals: { producto: @producto }, layout: false
  end

  # GET /productos/1/edit
  def edit
    render partial: 'form', locals: { producto: @producto }, layout: false
    
  end

  # POST /productos or /productos.json
  def create
    @producto = Producto.new(producto_params)

    if @producto.save
      if request.headers['Accept']&.include?('text/html')
        render partial: "admin/producto_card", locals: { producto: @producto }, status: :created
      else
        redirect_to productos_path, notice: 'Producto creado correctamente.'
      end
    else
      if request.headers['Accept']&.include?('text/html')
        render partial: "form", locals: { producto: @producto }, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /productos/1 or /productos/1.json
  def update
    respond_to do |format|
      if @producto.update(producto_params)
        format.html { redirect_to @producto, notice: "Producto was successfully updated." }
        format.json { render :show, status: :ok, location: @producto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productos/1 or /productos/1.json
  def destroy
    @producto.destroy!

    respond_to do |format|
      format.html { redirect_to productos_path, status: :see_other, notice: "Producto was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producto
      @producto = Producto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
def producto_params
  params.require(:producto).permit(:name, :foto, :precio, :descripcion, :grupo_id, adicional_ids: [])
end

end
