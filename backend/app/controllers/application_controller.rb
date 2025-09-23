class ApplicationController < ActionController::Base
  # Solo navegadores modernos
  allow_browser versions: :modern

  before_action :set_locale
  before_action :authenticate_user!  # asegura que solo usuarios logueados accedan
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
  if resource.is_a?(Admin)
    dashboard_root_path
  elsif resource.is_a?(User)
    root_path
  else
    root_path
  end
  end 

  protected

  def configure_permitted_parameters
    added_attrs = [
      :document_type, :document_number, :first_name, :last_name, :birthdate,
      :phone, :department, :city, :address, :email, :password, :password_confirmation, :current_password
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  # Detectar y guardar el idioma en sesión
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # Asegurar que todas las rutas generadas incluyan el locale
  def default_url_options
    { locale: I18n.locale }.merge(super)
  end
end
