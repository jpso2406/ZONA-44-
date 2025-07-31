class HomeController < ApplicationController
  def bienvenidos
  end

  def menu
    @grupos = Grupo.all
    @productos_en_carrito = productos_en_carrito
  end

  def contacto
  end

  private

  def productos_en_carrito
    ids = session[:carrito] || []
    Producto.where(id: ids)
  end
end
