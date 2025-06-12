class MenusController < ApplicationController
  def grupo
    @grupo = Grupo.find_by!(slug: params[:slug]) # o usa `id` si no tienes slug
    @productos = @grupo.productos
  end

end
