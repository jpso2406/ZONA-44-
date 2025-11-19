module Api
  module V1
    class AnunciosController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      # GET /api/v1/anuncios
      # Endpoint público para que los clientes vean los anuncios activos
      def index
        anuncios = Anuncio.visibles.with_attached_imagen

        render json: {
          success: true,
          anuncios: anuncios.map { |anuncio| anuncio_json(anuncio) }
        }
      end

      private

      def anuncio_json(anuncio)
        {
          id: anuncio.id,
          posicion: anuncio.posicion,
          imagen_url: anuncio.imagen.attached? ? url_for(anuncio.imagen) : nil,
          fecha_inicio: anuncio.fecha_inicio,
          fecha_fin: anuncio.fecha_fin
        }
      end
    end
  end
end
