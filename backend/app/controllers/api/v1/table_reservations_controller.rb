class Api::V1::TableReservationsController < ApplicationController
  # Permitir acceso sin autenticación y sin verificación CSRF para la API
  skip_before_action :authenticate_user!, only: [ :create ]
  skip_before_action :verify_authenticity_token
  # POST /api/v1/table_reservations
  def create
    @reservation = TableReservation.new(reservation_params)
    @reservation.status = "pendiente"
    @reservation.user_id = current_user.id if user_signed_in?
    if @reservation.save
      render json: { success: true, reservation: @reservation }, status: :created
    else
      render json: { success: false, errors: @reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/table_reservations
  def index
    if user_signed_in?
      @reservations = TableReservation.where(user_id: current_user.id)
      render json: @reservations
    else
      render json: { error: "No autenticado" }, status: :unauthorized
    end
  end

  # GET /api/v1/table_reservations/:id
  def show
    @reservation = TableReservation.find(params[:id])
    if @reservation.user_id == current_user&.id
      render json: @reservation
    else
      render json: { error: "No autorizado" }, status: :unauthorized
    end
  end

  # PATCH /api/v1/table_reservations/:id/cancel
  def cancel
    @reservation = TableReservation.find(params[:id])
    if @reservation.user_id == current_user&.id
      @reservation.update(status: "cancelada")
      render json: { success: true }
    else
      render json: { error: "No autorizado" }, status: :unauthorized
    end
  end

  private

  def reservation_params
    params.require(:table_reservation).permit(:name, :email, :phone, :date, :time, :people_count, :comments)
  end
end
