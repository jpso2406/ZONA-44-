class MenusController < ApplicationController
def grupo
  @grupo = Grupo.find(params[:id])
  @productos = @grupo.productos

  # Si el slug en la URL no coincide, redirige al correcto
  if params[:slug] != @grupo.slug
    return redirect_to menu_grupo_path(@grupo.id, @grupo.slug), status: :moved_permanently
  end
end


end
