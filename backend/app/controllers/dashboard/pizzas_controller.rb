class Dashboard::PizzasController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :require_admin!

  # 📄 Listado de pizzas
  def index
    @pizzas = Pizza.all.order(:id)
    @pizza = Pizza.new
  end

  # 🆕 Formulario para nueva pizza
  def new
    tipo = params[:tipo_pizza] || "tradicional"

    modelo = case tipo
            when "tradicional" then ::PizzaTradicional
            when "especial" then ::PizzaEspecial
            when "combinada" then ::PizzaCombinada
            else raise "Tipo de pizza desconocido"
            end

    @pizza = modelo.new

    @pizzas_tradicionales = PizzaTradicional.all
    @pizzas_especiales = PizzaEspecial.all
    @pizzas_combinadas = PizzaCombinada.all

    @tamano_pizzas = TamanoPizza.all
    @borde_quesos = BordeQueso.all
    @grupos = Grupo.all.order(:id)
  end



  # ➕ Crear pizza según tipo
    def create
    tipo = params[:tipo_pizza]

    modelo = case tipo
            when "tradicional" then ::PizzaTradicional
            when "especial" then ::PizzaEspecial
            when "combinada" then ::PizzaCombinada
            else raise "Tipo de pizza desconocido"
            end

    @pizza = modelo.new(pizza_params)

    if @pizza.save
      params[:precios]&.each do |tamano_id, precio|
        PizzaPrecio.create(
          pizza: @pizza,
          tamano_pizza_id: tamano_id,
          precio: precio,
          borde_queso: params[:borde_queso]&.key?(tamano_id),
          precio_borde: params[:precio_borde][tamano_id]
        )
      end

      redirect_to dashboard_pizzas_path, notice: "Pizza creada con éxito"
    else
      render :new
    end
  end
  # ✏️ Editar pizza
  def edit
  end 


  # ❌ Eliminar pizza
  def destroy
    @pizza = ::Pizza.find(params[:id])
    @pizza.destroy
    redirect_to dashboard_pizzas_path, notice: "Pizza eliminada con éxito"
  end

  private

  # 🔐 Parámetros permitidos
  def pizza_params
    params.require(:pizza).permit(:nombre, :descripcion, :activo, :grupo_id, :foto, :tipo_pizza)
  end

end
