class HomeController < ApplicationController
   skip_before_action :authenticate_user!, only: [:index, :menu, :contacto]


  def index
     @promociones = Promocion.all
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
