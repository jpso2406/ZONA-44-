module Api
  module V1
    class GruposController < ApplicationController
      skip_before_action :authenticate_user!
      def index
        grupos = Grupo.includes(productos: [foto_attachment: :blob])
        render json: grupos.as_json(
          only: [:id, :nombre, :slug],
          methods: [:foto_url],
          include: {
            productos: {
              only: [:id, :name, :precio, :descripcion],
              methods: [:foto_url]
            }
          }
        )
      end
    end
  end
end
