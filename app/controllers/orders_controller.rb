class OrdersController < ApplicationController

  def index
    @orders = Order.includes(:product).all # Optimize query to call once the orders and the products, much faster 
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
  end

  def create
  end

  def destroy
  end

end