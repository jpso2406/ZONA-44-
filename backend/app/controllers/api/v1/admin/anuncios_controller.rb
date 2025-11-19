module Api
  module V1
    module Admin
      class AnunciosController < ApplicationController
        skip_before_action :verify_authenticity_token
        skip_before_action :authenticate_user!
        before_action :authenticate_admin!, except: []
        before_action :set_anuncio, only: [ :show, :update, :destroy ]

      # GET /api/v1/admin/anuncios
      def index
        anuncios = Anuncio.with_attached_imagen
                          .order(posicion: :asc, created_at: :desc)

        render json: {
          success: true,
          anuncios: anuncios.map { |anuncio| anuncio_json(anuncio) }
        }
      end

      # GET /api/v1/admin/anuncios/:id
      def show
        render json: {
          success: true,
          anuncio: anuncio_json(@anuncio)
        }
      end

      # POST /api/v1/admin/anuncios
      def create
        anuncio = Anuncio.new(anuncio_params)

        if params[:imagen].present?
          anuncio.imagen.attach(params[:imagen])
        end

        if anuncio.save
          render json: {
            success: true,
            message: "Anuncio creado exitosamente",
            anuncio: anuncio_json(anuncio)
          }, status: :created
        else
          render json: {
            success: false,
            errors: anuncio.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/admin/anuncios/:id
      def update
        if params[:imagen].present?
          @anuncio.imagen.attach(params[:imagen])
        end

        if @anuncio.update(anuncio_params)
          render json: {
            success: true,
            message: "Anuncio actualizado exitosamente",
            anuncio: anuncio_json(@anuncio)
          }
        else
          render json: {
            success: false,
            errors: @anuncio.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/admin/anuncios/:id
      def destroy
        @anuncio.destroy
        render json: {
          success: true,
          message: "Anuncio eliminado exitosamente"
        }
      end

      private

      def set_anuncio
        @anuncio = Anuncio.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          success: false,
          error: "Anuncio no encontrado"
        }, status: :not_found
      end

      def anuncio_params
        params.permit(:activo, :posicion, :fecha_inicio, :fecha_fin)
      end

      def anuncio_json(anuncio)
        {
          id: anuncio.id,
          activo: anuncio.activo,
          posicion: anuncio.posicion,
          fecha_inicio: anuncio.fecha_inicio,
          fecha_fin: anuncio.fecha_fin,
          imagen_url: anuncio.imagen.attached? ? url_for(anuncio.imagen) : nil,
          created_at: anuncio.created_at,
          updated_at: anuncio.updated_at
        }
      end

      def authenticate_admin!
        # Implementar lógica de autenticación de admin
        # Por ahora permitimos acceso para desarrollo
        true
      end
      end
    end
  end
end
