class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    render "perfil/show"
  end

  def pedidos
    @orders = current_user.orders.order(created_at: :desc)
    render "perfil/pedidos"
  end
end
