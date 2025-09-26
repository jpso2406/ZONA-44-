class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @orders = current_user.orders.order(created_at: :desc)
    render "perfil/index"
  end
end
