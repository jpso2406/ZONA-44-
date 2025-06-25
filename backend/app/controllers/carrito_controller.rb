class CarritoController < ApplicationController
  def agregar
    producto_id = params[:producto_id].to_s

    session[:carrito] ||= []
    session[:carrito] << producto_id unless session[:carrito].include?(producto_id)

    producto = Producto.find_by(id: producto_id)
    if producto
      flash[:notice] = "#{producto.name} agregado al carrito."
    else
      flash[:alert] = "Producto no encontrado."
    end

    redirect_to request.referer || root_path
  end

  def mostrar
    ids = session[:carrito] || []
    @productos_en_carrito = Producto.where(id: ids)
  end

  def eliminar
    producto_id = params[:id].to_s
    session[:carrito] ||= []
    session[:carrito].delete(producto_id)

    flash[:notice] = "Producto eliminado del carrito."
    redirect_to mostrar_carrito_path
  end
end
