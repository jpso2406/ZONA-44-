require "google-id-token"

module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      # PUT /api/v1/profile
      def update
        user = User.find_by(api_token: request.headers["Authorization"])
        unless user
          return render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
        if user.update(user_params)
          render json: { success: true, message: "Usuario actualizado exitosamente" }
        else
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/profile
      def destroy
        user = User.find_by(api_token: request.headers["Authorization"])
        unless user
          return render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
        user.destroy
        render json: { success: true, message: "Usuario eliminado exitosamente" }
      end

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

      # POST /api/v1/auth/google
      def google
        id_token = params[:id_token]
        validator = GoogleIDToken::Validator.new
        begin
          payload = validator.check(id_token, ENV["GOOGLE_CLIENT_ID"])
          user = User.find_or_create_by(email: payload["email"]) do |u|
            u.first_name = payload["given_name"]
            u.last_name = payload["family_name"]
            u.password = SecureRandom.hex(16)
          end
          # Genera o retorna el api_token de tu modelo User
          user.update(api_token: SecureRandom.hex(32)) unless user.api_token.present?
          render json: { success: true, user: user.as_json(only: [:id, :email, :first_name, :last_name]), api_token: user.api_token }
        rescue => e
          render json: { success: false, error: e.message }, status: :unauthorized
        end
      end

      # GET /api/v1/profile
      def profile
        user = User.find_by(api_token: request.headers["Authorization"])
        if user
          render json: user.as_json(only: [ :id, :email, :first_name, :last_name, :phone, :address, :city, :department, :role ])
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
