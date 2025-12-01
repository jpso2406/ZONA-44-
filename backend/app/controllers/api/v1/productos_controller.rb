module Api
  module V1
    class ProductosController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :authenticate_admin!

      # GET /api/v1/productos
      def index
        productos = Producto.includes(foto_attachment: :blob)
        render json: productos.as_json(
          only: [ :id, :name, :precio, :descripcion, :grupo_id ],
          methods: [ :foto_url ]
        )
      end

      # POST /api/v1/productos
      def create
        producto = Producto.new(producto_params)
        if producto.save
          render json: { success: true, producto: producto }, status: :created
        else
          render json: { success: false, errors: producto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/productos/:id
      def update
        producto = Producto.find_by(id: params[:id])
        unless producto
          render json: { success: false, error: "Producto no encontrado" }, status: :not_found and return
        end
        if producto.update(producto_params)
          render json: { success: true, producto: producto }
        else
          render json: { success: false, errors: producto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/productos/:id
      def destroy
        producto = Producto.find_by(id: params[:id])
        unless producto
          render json: { success: false, error: "Producto no encontrado" }, status: :not_found and return
        end
        producto.destroy
        render json: { success: true, message: "Producto eliminado" }
      end

      private
      def producto_params
        params.require(:producto).permit(:name, :precio, :descripcion, :grupo_id, :foto)
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
