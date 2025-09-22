class Dashboard::GruposController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!
  def index
    @grupos = Grupo.all.order(:id)
    @grupo = Grupo.new
    
  end
  def new
    @grupo = Grupo.new
  end
  def create
    @grupo = Grupo.new(grupo_params)
    if @grupo.save
      redirect_to dashboard_grupos_path, notice: "Grupo creado con éxito"
    else
      render :new
    end
  end
  def edit
    @grupo = Grupo.find(params[:id])
    
  end
  def update
    @grupo = Grupo.find(params[:id])
    if @grupo.update(grupo_params)
      redirect_to dashboard_grupos_path, notice: "Grupo actualizado con éxito"
    else
      render :edit
    end
  end
  def destroy
    @grupo = Grupo.find(params[:id])
    if @grupo.destroy
      redirect_to dashboard_grupos_path, notice: "Grupo eliminado con éxito"
    else
      redirect_to dashboard_grupos_path, alert: "Error al eliminar el grupo"
    end
  end
  private
  def grupo_params
    params.require(:grupo).permit(:nombre, :slug, :imagen)
  end
end
