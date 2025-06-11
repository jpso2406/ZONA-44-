class CarritoController < ApplicationController
  def agregar
    producto = params[:producto]

    # Inicializa el carrito si no existe
    session[:carrito] ||= []
    session[:carrito] << producto

    flash[:notice] = "#{producto.humanize} agregado al carrito."
    redirect_to request.referer || root_path
  end

  def mostrar
    @productos_en_carrito = session[:carrito] || []
  end
end