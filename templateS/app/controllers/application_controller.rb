class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout 'vertical'

  def after_sign_in_path_for(resource)
    users_dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path # Esto te lleva a home#bienvenida
  end
end
