class Dashboard::PizzaController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!
  def index
    
  end

  def show
  end

  def edit
    
    @pizza = Pizza.find(params[:id])
    @tamano_pizzas = TamanoPizza.all
    @borde_quesos = BordeQueso.all
    @grupos = Grupo.all.order(:id)

  end

  def new
    @pizza = Pizza.new
    @tamano_pizzas = TamanoPizza.all
    @borde_quesos = BordeQueso.all
    @grupos = Grupo.all.order(:id)
  end
  def create
    @pizza = Pizza.new(pizza_params)
    if @pizza.save
      redirect_to dashboard_pizza_path(@pizza), notice: "Pizza creada con éxito"
    else
      render :new
    end
  end
  def update
    @pizza = Pizza.find(params[:id])
    if @pizza.update(pizza_params)
      redirect_to dashboard_pizza_path(@pizza), notice: "Pizza actualizada con éxito"
    else
      render :edit
    end
  end
  def destroy
    @pizza = Pizza.find(params[:id])
    if @pizza.destroy
      redirect_to dashboard_pizza_index_path, notice: "Pizza eliminada con éxito"
    else
      redirect_to dashboard_pizza_index_path, alert: "Error al eliminar la pizza"
    end
  end
  
end
