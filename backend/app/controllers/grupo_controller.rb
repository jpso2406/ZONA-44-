class GrupoController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_grupo, only: [ :show ]

  def index
    @grupos = Grupo.all.order(:id)
  end

  def show
  end

  private

  def set_grupo
    @grupo = Grupo.find(params[:id])
  end
end
