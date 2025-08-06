class Api::V1::ProductosController < ApplicationController
  
  def index
    productos = Producto.all 
    render json: productos.as_json()
  end 
end
