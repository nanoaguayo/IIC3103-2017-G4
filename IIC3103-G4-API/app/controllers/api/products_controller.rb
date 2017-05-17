class Api::ProductsController < Api::ApplicationController

  def index
    updateStock
    @products = Product.all
  end

  def updateStock
    prods = Fetcher.getProductsWithStock
    prods2 = Product.all
    for prod in prods2 do
      prod.stock = prods[prod.sku]
      prod.save
    end
  end

end
