class MenusController < ApplicationController   
  def grupo
    # Buscar el grupo por ID, manejar si no existe
    @grupo = Grupo.find_by(id: params[:id])
    
    unless @grupo
      redirect_to menu_general_path, alert: "Grupo no encontrado"
      return
    end

    # Redirección permanente si el slug en la URL no coincide con el del grupo
    if params[:slug] != @grupo.slug
      return redirect_to menu_grupo_path(@grupo.id, @grupo.slug), status: :moved_permanently
    end

    # Guardar en sesión el grupo actual para volver desde el carrito
    session[:grupo_actual_id] = @grupo.id
    session[:grupo_actual_slug] = @grupo.slug

    # Cargar productos optimizando la carga de imágenes (evita N+1)
    @productos = @grupo.productos.includes(foto_attachment: :blob)
  end

  def general
    # Cargar todos los grupos con sus productos e imágenes asociadas
    @grupos = Grupo.includes(productos: [foto_attachment: :blob])

    # Limpiar la sesión al volver al menú general
    session.delete(:grupo_actual_id)
    session.delete(:grupo_actual_slug)
  end
end
