module Api
  module V1
    class GruposController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :verify_authenticity_token
      before_action :authenticate_admin!, except: [ :index ]

      def index
        grupos = Grupo.includes(
          foto_attachment: :blob,
          productos: [ foto_attachment: :blob ]
        )
        render json: grupos.as_json(
          only: [ :id, :nombre, :slug ],
          methods: [ :foto_url ],
          include: {
            productos: {
              only: [ :id, :name, :precio, :descripcion ],
              methods: [ :foto_url ]
            }
          }
        )
      end

      # POST /api/v1/grupos
      def create
        grupo = Grupo.new(grupo_params)
        if grupo.save
          render json: { success: true, grupo: grupo }, status: :created
        else
          render json: { success: false, errors: grupo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/grupos/:id
      def update
        grupo = Grupo.find_by(id: params[:id])
        unless grupo
          render json: { success: false, error: "Grupo no encontrado" }, status: :not_found and return
        end
        if grupo.update(grupo_params)
          render json: { success: true, grupo: grupo }
        else
          render json: { success: false, errors: grupo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/grupos/:id
      def destroy
        grupo = Grupo.find_by(id: params[:id])
        unless grupo
          render json: { success: false, error: "Grupo no encontrado" }, status: :not_found and return
        end
        grupo.destroy
        render json: { success: true, message: "Grupo eliminado" }
      end

      private
      def grupo_params
        params.require(:grupo).permit(:nombre, :slug, :descripcion)
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
