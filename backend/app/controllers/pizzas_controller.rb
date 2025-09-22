class PizzasController < ApplicationController
  before_action :authenticate_admin!, except: [ :index, :show ]

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
    render partial: "admin/form_pizza", layout: false
  end

  def create
    tipo = params[:tipo_pizza]
    model = tipo == "especial" ? PizzaEspecial : PizzaTradicional
    grupo = Grupo.find_by(nombre: tipo == "especial" ? "Pizzas Especiales" : "Pizzas Tradicionales")

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
      render partial: "admin/form_pizza", locals: { pizza: pizza }, status: :unprocessable_entity
    end
  end

  def edit
    @pizza = find_pizza
    @tamanos = TamanoPizza.ordenados
    render partial: "admin/form_edit_pizza", locals: { pizza: @pizza, tamanos: @tamanos }, layout: false
  end

  def update
    @pizza = find_pizza
    success = @pizza.update(pizza_params)

    # Procesar precios por tamaño
    precios_params = params[:precios] || {}
    precios_params.each do |tamano_id, precio|
      if precio.present?
        pizza_tamano = @pizza.pizza_tamanos.find_or_initialize_by(tamano_pizza_id: tamano_id)
        pizza_tamano.precio = precio
        pizza_tamano.save!
      end
    end

    # Procesar bordes de queso por tamaño
    todos_tamanos = TamanoPizza.all.pluck(:id).map(&:to_s)
    borde_params = params[:borde_queso] || {}
    precio_params = params[:precio_borde] || {}
    todos_tamanos.each do |tamano_id|
      borde = BordeQueso.find_by(tamano_pizza_id: tamano_id)
      permitido = borde_params[tamano_id]
      precio = precio_params[tamano_id]
      if permitido == "on" && precio.present?
        if borde
          borde.update(precio: precio)
        else
          BordeQueso.create!(tamano_pizza_id: tamano_id, precio: precio)
        end
      elsif borde
        borde.destroy
      end
    end

    # Recarga asociaciones para reflejar los cambios
    @pizza.reload
    @pizza.pizza_tamanos.reload if @pizza.respond_to?(:pizza_tamanos)
    @pizza.tamanos.reload if @pizza.respond_to?(:tamanos)

    if success
      partial_name = @pizza.is_a?(PizzaEspecial) ? "admin/pizza_especial_card" : "admin/pizza_tradicional_card"
      render partial: partial_name, locals: { pizza: @pizza }, status: :ok
    else
      @tamanos = TamanoPizza.ordenados
      render partial: "admin/form_pizza", locals: { pizza: @pizza }, status: :unprocessable_entity
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
    p = params[:pizza] || params[:pizza_tradicional] || params[:pizza_especial]
    if p.is_a?(ActionController::Parameters)
      p.permit(:nombre, :descripcion, :categoria, :foto, pizza_tamanos_attributes: [ :id, :tamano_pizza_id, :precio, :_destroy ])
    else
      ActionController::Parameters.new(p).permit(:nombre, :descripcion, :categoria, :foto, pizza_tamanos_attributes: [ :id, :tamano_pizza_id, :precio, :_destroy ])
    end
  end
end
