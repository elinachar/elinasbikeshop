class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @orders = Order.includes(:product).where("user_id = ?", current_user.id) # Optimize query to call once the orders and the products, much faster
  end

  def show
    @order = Order.find(params[:id])
  end

end
