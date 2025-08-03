class Grupo::ProductoController < ApplicationController
  before_action :set_grupo
  before_action :set_product, only: [:show]
  
  def index
    @productos = @grupo.productos
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
