class CarritoController < ApplicationController  
  def agregar
    producto_id = params[:producto_id].to_s
    session[:carrito] ||= []
    session[:carrito] << producto_id

    producto = Producto.find_by(id: producto_id)
    if producto
      flash[:notice] = "#{producto.name} agregado al carrito."
    else
      flash[:alert] = "Producto no encontrado."
    end

    respond_to do |format|
      format.html { redirect_to request.referer || root_path }
      format.json { render json: { status: "ok" } }
    end
  end

  def reducir
    producto_id = params[:id].to_s
    session[:carrito] ||= []

    index = session[:carrito].index(producto_id)
    if index
      session[:carrito].delete_at(index)
      flash[:notice] = "Cantidad reducida del producto."
    else
      flash[:alert] = "El producto no se encuentra en el carrito."
    end

    redirect_to mostrar_carrito_path
  end

  def eliminar
    producto_id = params[:id].to_s
    session[:carrito] ||= []
    session[:carrito].delete(producto_id)

    flash[:notice] = "Producto eliminado del carrito."
    redirect_to mostrar_carrito_path
  end

  def mostrar
    ids = session[:carrito] || []
    
    # Contar repeticiones (cantidades)
    conteo = ids.tally

    # Buscar los productos únicos y agregar cantidad a cada uno
    @productos_en_carrito = Producto.where(id: conteo.keys).includes(foto_attachment: :blob).map do |producto|
      producto.define_singleton_method(:cantidad) { conteo[producto.id.to_s] || 0 }
      producto
    end

    # Para permitir volver al grupo anterior desde el carrito
    @grupo_actual_id = session[:grupo_actual_id]
    @grupo_actual_slug = session[:grupo_actual_slug]
  end
end
