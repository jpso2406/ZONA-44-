class AdminController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  def dashboard
    @grupos = Grupo.all
    if params[:grupo_id].present?
      @productos = Producto.where(grupo_id: params[:grupo_id])
      @pizzas_tradicionales = PizzaTradicional.where(grupo_id: params[:grupo_id])
      @pizzas_especiales = PizzaEspecial.where(grupo_id: params[:grupo_id])
      @pizzas_combinadas = PizzaCombinada.where(grupo_id: params[:grupo_id])
    else
      @productos = Producto.all
      @pizzas_tradicionales = PizzaTradicional.all
      @pizzas_especiales = PizzaEspecial.all
      @pizzas_combinadas = PizzaCombinada.all
    end
  end
end
