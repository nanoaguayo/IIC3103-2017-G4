Rails.application.configure do
  #update the stock before launching the site
  config.after_initialize do
    if defined?(Rails::Server)
      prods = Fetcher.getProductsWithStock
      prods2 = Product.all
      prods3 = Spree::Product.all
      vars = Spree::Variant.all
      for prod in prods2 do
        prod.stock = prods[prod.sku]
        prod.save
      end
      for prod in prods3 do
        for variant in vars do
          if variant.sku == prod.sku then
            var_aux = Spree::Variant.find(variant)
            var_aux.stock_items.first.set_count_on_hand(prods[variant.sku])
            var_aux.save
          end
        end
      end
    end
  end
end
