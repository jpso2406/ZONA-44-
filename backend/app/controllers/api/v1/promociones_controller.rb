module Api
  module V1
    class PromocionesController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :authenticate_admin!
      before_action :set_promocion, only: [ :show, :update, :destroy ]

      # GET /api/v1/promociones
      def index
        promociones = Promocion.includes(:producto).order(created_at: :desc)
        render json: promociones.map { |p| promocion_json(p) }
      end

      # GET /api/v1/promociones/:id
      def show
        render json: promocion_json(@promocion)
      end

      # POST /api/v1/promociones
      def create
        promocion = Promocion.new(promocion_params)
        promocion.imagen.attach(params[:promocion][:imagen]) if params[:promocion][:imagen].present?
        if promocion.save
          render json: { success: true, promocion: promocion_json(promocion) }, status: :created
        else
          render json: { success: false, errors: promocion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/promociones/:id
      def update
        if @promocion.update(promocion_params)
          @promocion.imagen.attach(params[:promocion][:imagen]) if params[:promocion][:imagen].present?
          render json: { success: true, promocion: promocion_json(@promocion) }
        else
          render json: { success: false, errors: @promocion.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/promociones/:id
      def destroy
        @promocion.destroy
        render json: { success: true, message: "Promoción eliminada" }
      end

      private
      def set_promocion
        @promocion = Promocion.find_by(id: params[:id])
        unless @promocion
          render json: { success: false, error: "Promoción no encontrada" }, status: :not_found
        end
      end

      def promocion_params
        params.require(:promocion).permit(:nombre, :precio_total, :precio_original, :descuento, :producto_id, :imagen)
      end

      def promocion_json(promocion)
        promocion.as_json(
          include: { producto: { only: [ :id, :name, :precio, :descripcion ] } }
        ).merge(
          imagen_url: promocion.imagen.attached? ? url_for(promocion.imagen) : nil
        )
      end

      def authenticate_admin!
        user = User.find_by(api_token: request.headers["Authorization"])
        unless user&.admin?
          render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
      end
    end
  end
end
