class CarritoController < ApplicationController
  def agregar
    producto = params[:producto]
    flash[:notice] = "#{producto.humanize} agregado al carrito."
    redirect_to request.referer || root_path
  end
end