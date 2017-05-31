class Api::ProductsController < Api::ApplicationController

  def index
    updateStock
    @products = Product.all
    render json: @products
  end

  def updateStock
    prods = Fetcher.getProductsWithStock
    prods2 = Product.all
    for prod in prods2 do
      prod.stock = prods[prod.sku]
      prod.save
    end
  end

  def publico
  	skus = SkuGroup.where(group: 4).map(&:sku)
  	updateStock
  	ret = Array.new
  	skus.each do |sku|
  		prod = Product.find_by(sku: sku)
  		ret << {sku: prod.sku, precio: prod.price, stock: prod.stock}
  	end
  	render json: ret
  end

end
