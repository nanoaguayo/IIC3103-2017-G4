class ProductsController < ApplicationController

  def index
    updateStock
    @products = Product.all
  end

  def updateStock
    prods = Fetcher.getProductsWithStock
    prods2 = Product.all
    prods3 = Spree::Product.all
    vars = Spree::Variant.all
    puts prods3
    puts vars
    for prod in prods2 do
      prod.stock = prods[prod.sku]
      prod.save
    end
    for prod in prods3 do
      for variant in vars do
        if variant.sku == prod.sku then
          var_aux = Spree::Variant.find(variant)
          var_aux.stock_items.first.adjust_count_on_hand(prods[variant.sku])
          puts var_aux.stock_items.first.inspect
          var_aux.save
        end
      end
    end
    render json:{
      'msg': 'ok'
    }
  end

end
