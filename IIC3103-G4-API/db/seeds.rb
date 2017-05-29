# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
Spree::Product.delete_all
Spree::Variant.delete_all

'iva'
tax_category = Spree::TaxCategory.create(name:'IVA', is_default: true)
tax_category.save
'valor iva'
tax_rate = Spree::TaxRate.create(amount: 0.19, tax_category_id: 1, included_in_price: true)
tax_rate.save


#productos
Product.delete_all
prod = Product.create(sku:2,description:"Huevo",prodType:"Materia Prima",unit_cost:102,lot:150,prod_time:2.011,stock:0,price:306)
prod.save
producto = Spree::Product.create(sku: "2", cost_currency: "CLP", name: "Huevo", description: "Huevos", available_on: Time.now, meta_keywords: "Huevo", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 306)
producto.save
prod = Product.create(sku:4,description:"Aceite de Maravilla",prodType:"Procesado",unit_cost:412,lot:200,prod_time:2.713,stock:0,price:1236)
prod.save
producto = Spree::Product.create(sku: "4", cost_currency: "CLP", name: "Aceite de Maravilla", description: "Aceite de maravilla procesado", available_on: Time.now, meta_keywords: "Aceite,Maravilla", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 1236)
producto.save
prod = Product.create(sku:8,description:"Trigo",prodType:"Materia Prima",unit_cost:252,lot:100,prod_time:2.531,stock:0,price:756)
prod.save
producto = Spree::Product.create(sku: "8", cost_currency: "CLP", name: "Trigo", description: "Trigo", available_on: Time.now, meta_keywords: "Trigo", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 756)
producto.save
prod = Product.create(sku:10,description:"Pan Marraqueta",prodType:"Procesado",unit_cost:1084,lot:900,prod_time:2.771,stock:0,price:3232)
prod.save
producto = Spree::Product.create(sku: "10", cost_currency: "CLP", name: "Pan Marraqueta", description: "Pan Marraqueta procesado", available_on: Time.now, meta_keywords: "Pan,Marraqueta", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 3232)
producto.save
prod = Product.create(sku:14,description:"Cebada",prodType:"Procesado",unit_cost:296,lot:1750,prod_time:2.220,stock:0,price:888)
prod.save
producto = Spree::Product.create(sku: "14",cost_currency: "CLP", name: "Cebada", description: "Cebada procesada", available_on: Time.now, meta_keywords: "Cebada", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 888)
producto.save
prod = Product.create(sku:16,description:"Pasta de trigo",prodType:"Procesado",unit_cost:612,lot:1000,prod_time:2.493,stock:0,price:1836)
prod.save
producto = Spree::Product.create(sku: "16",cost_currency: "CLP", name: "Pasta de trigo", description: "Pasta de trigo procesada", available_on: Time.now, meta_keywords: "Pasta,Trigo", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 1836)
producto.save
prod = Product.create(sku:20,description:"Cacao",prodType:"Materia Prima",unit_cost:172,lot:60,prod_time:1.955,stock:0,price:516)
prod.save
producto = Spree::Product.create(sku: "20",cost_currency: "CLP", name: "Cacao", description: "Cacao", available_on: Time.now, meta_keywords: "Cacao", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 516)
producto.save
prod = Product.create(sku:26,description:"Sal",prodType:"Materia Prima",unit_cost:99,lot:144,prod_time:1.242,stock:0,price:297)
prod.save
producto = Spree::Product.create(sku: "26",cost_currency: "CLP", name: "Sal", description: "Sal", available_on: Time.now, meta_keywords: "Sal", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 297)
producto.save
prod = Product.create(sku:50,description:"Arroz con leche",prodType:"Procesado",unit_cost:773,lot:350,prod_time:2.832,stock:0,price:2319)
prod.save
producto = Spree::Product.create(sku: "50",cost_currency: "CLP", name: "Arroz con leche", description: "Arroz con leche procesado", available_on: Time.now, meta_keywords: "Arroz,Leche", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 2319)
producto.save
prod = Product.create(sku:54,description:"Hamburguesas",prodType:"Procesado",unit_cost:606,lot:1800,prod_time:0.860,stock:0,price:1818)
prod.save
producto = Spree::Product.create(sku: "54", cost_currency: "CLP", name: "Hamburguesas", description: "Hamburguesas procesadas", available_on: Time.now, meta_keywords: "Hamburguesa", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 1818)
producto.save
prod = Product.create(sku:55,description:"Galletas Integrales",prodType:"Procesado",unit_cost:925,lot:950,prod_time:3.283,stock:0,price:2775)
prod.save
producto = Spree::Product.create(sku: "55",cost_currency: "CLP", name: "Galletas integrales", description: "Galletas integrales procesadas", available_on: Time.now, meta_keywords: "Galleta,Integral", tax_category_id: 1, shipping_category_id: 1, promotionable: false, price: 2775)
producto.save

#tuplas sku-grupo
SkuGroup.delete_all
sku = SkuGroup.create(sku:1,group:1)
sku.save
sku = SkuGroup.create(sku:1,group:3)
sku.save
sku = SkuGroup.create(sku:2,group:2)
sku.save
sku = SkuGroup.create(sku:2,group:6)
sku.save
sku = SkuGroup.create(sku:3,group:3)
sku.save
sku = SkuGroup.create(sku:3,group:5)
sku.save
sku = SkuGroup.create(sku:4,group:6)
sku.save
sku = SkuGroup.create(sku:4,group:8)
sku.save
sku = SkuGroup.create(sku:5,group:5)
sku.save
sku = SkuGroup.create(sku:6,group:6)
sku.save
sku = SkuGroup.create(sku:6,group:8)
sku.save
sku = SkuGroup.create(sku:6,group:2)
sku.save
sku = SkuGroup.create(sku:7,group:1)
sku.save
sku = SkuGroup.create(sku:7,group:3)
sku.save
sku = SkuGroup.create(sku:7,group:5)
sku.save
sku = SkuGroup.create(sku:7,group:7)
sku.save
sku = SkuGroup.create(sku:8,group:2)
sku.save
sku = SkuGroup.create(sku:8,group:6)
sku.save
sku = SkuGroup.create(sku:9,group:3)
sku.save
sku = SkuGroup.create(sku:9,group:5)
sku.save
sku = SkuGroup.create(sku:11,group:5)
sku.save
sku = SkuGroup.create(sku:12,group:6)
sku.save
sku = SkuGroup.create(sku:13,group:7)
sku.save
sku = SkuGroup.create(sku:13,group:1)
sku.save
sku = SkuGroup.create(sku:13,group:3)
sku.save
sku = SkuGroup.create(sku:14,group:2)
sku.save
sku = SkuGroup.create(sku:15,group:3)
sku.save
sku = SkuGroup.create(sku:15,group:5)
sku.save
sku = SkuGroup.create(sku:17,group:5)
sku.save
sku = SkuGroup.create(sku:18,group:6)
sku.save
sku = SkuGroup.create(sku:19,group:6)
sku.save
sku = SkuGroup.create(sku:19,group:8)
sku.save
sku = SkuGroup.create(sku:20,group:2)
sku.save
sku = SkuGroup.create(sku:20,group:6)
sku.save
sku = SkuGroup.create(sku:20,group:8)
sku.save
sku = SkuGroup.create(sku:22,group:1)
sku.save
sku = SkuGroup.create(sku:22,group:3)
sku.save
sku = SkuGroup.create(sku:22,group:5)
sku.save
sku = SkuGroup.create(sku:23,group:6)
sku.save
sku = SkuGroup.create(sku:23,group:7)
sku.save
sku = SkuGroup.create(sku:23,group:8)
sku.save
sku = SkuGroup.create(sku:23,group:1)
sku.save
sku = SkuGroup.create(sku:25,group:1)
sku.save
sku = SkuGroup.create(sku:25,group:3)
sku.save
sku = SkuGroup.create(sku:25,group:5)
sku.save
sku = SkuGroup.create(sku:25,group:7)
sku.save
sku = SkuGroup.create(sku:26,group:2)
sku.save
sku = SkuGroup.create(sku:26,group:6)
sku.save
sku = SkuGroup.create(sku:26,group:8)
sku.save
sku = SkuGroup.create(sku:27,group:6)
sku.save
sku = SkuGroup.create(sku:27,group:7)
sku.save
sku = SkuGroup.create(sku:27,group:8)
sku.save
sku = SkuGroup.create(sku:34,group:1)
sku.save
sku = SkuGroup.create(sku:38,group:7)
sku.save
sku = SkuGroup.create(sku:38,group:8)
sku.save
sku = SkuGroup.create(sku:39,group:1)
sku.save
sku = SkuGroup.create(sku:39,group:2)
sku.save
sku = SkuGroup.create(sku:40,group:2)
sku.save
sku = SkuGroup.create(sku:41,group:2)
sku.save
sku = SkuGroup.create(sku:41,group:3)
sku.save
sku = SkuGroup.create(sku:41,group:7)
sku.save
sku = SkuGroup.create(sku:42,group:8)
sku.save
sku = SkuGroup.create(sku:46,group:1)
sku.save
sku = SkuGroup.create(sku:47,group:7)
sku.save
sku = SkuGroup.create(sku:48,group:3)
sku.save
sku = SkuGroup.create(sku:49,group:1)
sku.save
sku = SkuGroup.create(sku:49,group:2)
sku.save
sku = SkuGroup.create(sku:49,group:3)
sku.save
sku = SkuGroup.create(sku:51,group:7)
sku.save
sku = SkuGroup.create(sku:52,group:3)
sku.save
sku = SkuGroup.create(sku:52,group:5)
sku.save
sku = SkuGroup.create(sku:52,group:7)
sku.save
sku = SkuGroup.create(sku:53,group:8)
sku.save
sku = SkuGroup.create(sku:56,group:5)
sku.save


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
#Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
