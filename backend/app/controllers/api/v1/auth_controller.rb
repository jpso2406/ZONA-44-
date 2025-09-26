module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      # POST /api/v1/register
      def register
        user = User.new(user_params)
        if user.save
          render json: { success: true, user_id: user.id, message: "Usuario registrado exitosamente" }
        else
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/login
      def login
        email = params[:email] || params.dig(:auth, :email)
        password = params[:password] || params.dig(:auth, :password)
        user = User.find_by(email: email)
        if user && user.valid_password?(password)
          # Generar token simple (puedes cambiar por JWT)
          token = SecureRandom.hex(32)
          user.update(api_token: token)
          render json: { success: true, user_id: user.id, token: token }
        else
          render json: { success: false, message: "Credenciales inválidas" }, status: :unauthorized
        end
      end

      # GET /api/v1/profile
      def profile
        user = User.find_by(api_token: request.headers["Authorization"])
        if user
          render json: user.as_json(only: [ :id, :email, :first_name, :last_name, :phone, :address, :city, :department ])
        else
          render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
      end

      private
      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name, :phone, :address, :city, :department)
      end
    end
  end
end
