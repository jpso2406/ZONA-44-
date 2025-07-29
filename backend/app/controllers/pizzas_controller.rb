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
    @pizza = PizzaTradicional.new
    @tamanos = TamanoPizza.ordenados
  end
  
  def create
    @pizza = PizzaTradicional.new(pizza_params)
    
    if @pizza.save
      redirect_to pizzas_path, notice: 'Pizza creada exitosamente.'
    else
      @tamanos = TamanoPizza.ordenados
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @pizza = find_pizza
    @tamanos = TamanoPizza.ordenados
  end
  
  def update
    @pizza = find_pizza
    
    if @pizza.update(pizza_params)
      redirect_to pizzas_path, notice: 'Pizza actualizada exitosamente.'
    else
      @tamanos = TamanoPizza.ordenados
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @pizza = find_pizza
    @pizza.destroy
    redirect_to pizzas_path, notice: 'Pizza eliminada exitosamente.'
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