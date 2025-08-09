class Dashboard::DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_admin!

  def after_sign_in_path_for(resource)
    dashboard_root_path
  end


  def index
    
  end
end
