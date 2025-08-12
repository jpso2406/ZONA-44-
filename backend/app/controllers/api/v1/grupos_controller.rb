module Api
  module V1
    class GruposController < ApplicationController
      def index
        grupos = Grupo.includes(productos: [foto_attachment: :blob])
        render json: grupos.as_json(
          only: [:id, :nombre, :slug],
          include: {
            productos: {
              only: [:id, :nombre, :precio, :descripcion],
              methods: [:foto_url]
            }
          }
        )
      end
    end
  end
end
