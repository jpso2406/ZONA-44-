class MenusController < ApplicationController 

  def grupo
    @grupo = Grupo.find(params[:id])
    @productos = @grupo.productos

    # Redirección si el slug no coincide
    if params[:slug] != @grupo.slug
      return redirect_to menu_grupo_path(@grupo.id, @grupo.slug), status: :moved_permanently
    end
  end

  def general
    @grupos = Grupo.all.includes(:productos)
  end

end
