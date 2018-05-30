class SimplePagesController < ApplicationController
  def index
  end

  def landing_page
    @products = Product.last(4)
  end
end
