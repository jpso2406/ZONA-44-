class HomeController < ApplicationController
  def bienvenidos
  end

 def menu
    @grupos = Grupo.all
  end
end
