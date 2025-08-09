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
end
