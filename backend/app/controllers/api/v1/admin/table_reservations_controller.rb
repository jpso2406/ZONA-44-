class Api::V1::Admin::TableReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :authenticate_admin!

  # GET /api/v1/admin/table_reservations
  def index
    @reservations = TableReservation.all.order(created_at: :desc)
    render json: @reservations
  end

  # GET /api/v1/admin/table_reservations/:id
  def show
    render json: @reservation
  end

  # PATCH /api/v1/admin/table_reservations/:id
  def update
    prev_status = @reservation.status
    if @reservation.update(reservation_params)
      if prev_status != "confirmada" && @reservation.status == "confirmada"
        # Aquí se enviará el correo (se implementará en el siguiente paso)
        TableReservationMailer.with(reservation: @reservation).confirmation_email.deliver_later
      end
      render json: { success: true, reservation: @reservation }
    else
      render json: { success: false, errors: @reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/admin/table_reservations/:id
  def destroy
    @reservation.destroy
    render json: { success: true }
  end

  private

  def set_reservation
    @reservation = TableReservation.find(params[:id])
  end

  def reservation_params
    params.require(:table_reservation).permit(:status, :comments)
  end

  # AGREGAR ESTE MÉTODO (igual que en AdminOrdersController):
  def authenticate_admin!
    user = User.find_by(api_token: request.headers["Authorization"])
    unless user&.admin?
      render json: { success: false, message: "No autorizado" }, status: :unauthorized
    end
  end
end