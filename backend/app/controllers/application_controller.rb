class ApplicationController < ActionController::Base
  # Solo navegadores modernos
  allow_browser versions: :modern

  before_action :set_locale

  def after_sign_in_path_for(resource)
    dashboard_root_path
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