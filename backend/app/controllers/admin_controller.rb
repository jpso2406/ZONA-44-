class AdminController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def dashboard
    @grupos = Grupo.all
  end
end
