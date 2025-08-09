class Dashboard::PromocionesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!
  before_action :set_promocion, only: [:destroy]

  def index
    @promociones = Promocion.all.order(:id)
  end
  def new
    @promocion = Promocion.new
  end
  def create
    @promocion = Promocion.new(promocion_params)
    if @promocion.save
      redirect_to dashboard_promociones_path, notice: "Promoción creada con éxito"
    else
      render :new
    end
  end
  def destroy
    @promocion = Promocion.find(params[:id])
    @promocion.destroy
    redirect_to dashboard_promociones_path, notice: "Promoción eliminada con éxito"
  end
end
