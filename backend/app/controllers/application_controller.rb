class ApplicationController < ActionController::Base
  # Solo navegadores modernos
  allow_browser versions: :modern

  before_action :set_locale
  before_action :authenticate_user!  # asegura que solo usuarios logueados accedan

  def after_sign_in_path_for(resource)
  if resource.is_a?(Admin)
    dashboard_root_path
  elsif resource.is_a?(User)
    root_path
  else
    root_path
  end
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
