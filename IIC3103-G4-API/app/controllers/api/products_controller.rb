class Api::ProductsController < Api::ApplicationController

  def index
    @products = Product.all
  end
end
