class PizzasController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]
  
  def index
    @pizzas_tradicionales = PizzaTradicional.all
    @pizzas_especiales = PizzaEspecial.all
    @pizza_combinada = PizzaCombinada.first
    @tamanos = TamanoPizza.ordenados
  end
  
  def show
    @pizza = find_pizza
    @tamanos = @pizza.tamanos_disponibles
  end
  
  def new
    render partial: 'admin/form_pizza', layout: false
  end

  def create
    tipo = params[:tipo_pizza]
    model = tipo == 'especial' ? PizzaEspecial : PizzaTradicional
    grupo = Grupo.find_by(nombre: tipo == 'especial' ? 'Pizzas Especiales' : 'Pizzas Tradicionales')

    pizza = model.new(
      nombre: params[:nombre],
      descripcion: params[:descripcion],
      categoria: tipo,
      grupo: grupo
    )
    pizza.foto.attach(params[:foto]) if params[:foto].present?

    if pizza.save
      # Precios por tamaño y borde de queso
      (params[:precios] || {}).each do |tamano_id, precio|
        PizzaTamano.create!("pizza_#{tipo}": pizza, tamano_pizza_id: tamano_id, precio: precio)
        if params[:borde_queso]&.[](tamano_id)
          BordeQueso.create!(tamano_pizza_id: tamano_id, precio: params[:precio_borde][tamano_id])
        end
      end
      render partial: "admin/pizza_#{tipo}_card", locals: { pizza: pizza }, status: :created
    else
      render partial: 'admin/form_pizza', locals: { pizza: pizza }, status: :unprocessable_entity
    end
  end
  
  def edit
    @pizza = find_pizza
    @tamanos = TamanoPizza.ordenados
  end
  
  def update
    @pizza = find_pizza
    if @pizza.update(pizza_params)
      render partial: "admin/pizza_#{@pizza.categoria}_card", locals: { pizza: @pizza }, status: :ok
    else
      @tamanos = TamanoPizza.ordenados
      render partial: 'admin/form_pizza', locals: { pizza: @pizza }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @pizza = find_pizza
    @pizza.destroy
    head :no_content
  end
  
  private
  
  def find_pizza
    pizza = PizzaTradicional.find_by(id: params[:id])
    pizza ||= PizzaEspecial.find_by(id: params[:id])
    pizza ||= PizzaCombinada.find_by(id: params[:id])
    pizza
  end
  
  def pizza_params
    params.require(:pizza).permit(:nombre, :descripcion, :categoria, :foto, pizza_tamanos_attributes: [:id, :tamano_pizza_id, :precio, :_destroy])
  end
end 