# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#productos
Product.delete_all
prod = Product.create(sku:2,description:"Huevo",prodType:"Materia Prima",unit_cost:102,lot:150,prod_time:2.011,stock:0,price:306)
prod.save
prod = Product.create(sku:4,description:"Aceite de Maravilla",prodType:"Procesado",unit_cost:412,lot:200,prod_time:2.713,stock:0,price:1236)
prod.save
prod = Product.create(sku:8,description:"Trigo",prodType:"Materia Prima",unit_cost:252,lot:100,prod_time:2.531,stock:0,price:756)
prod.save
prod = Product.create(sku:10,description:"Pan Marraqueta",prodType:"Procesado",unit_cost:1084,lot:900,prod_time:2.771,stock:0,price:3232)
prod.save
prod = Product.create(sku:14,description:"Cebada",prodType:"Procesado",unit_cost:296,lot:1750,prod_time:2.220,stock:0,price:888)
prod.save
prod = Product.create(sku:16,description:"Pasta de trigo",prodType:"Procesado",unit_cost:612,lot:1000,prod_time:2.493,stock:0,price:1836)
prod.save
prod = Product.create(sku:20,description:"Cacao",prodType:"Materia Prima",unit_cost:172,lot:60,prod_time:1.955,stock:0,price:516)
prod.save
prod = Product.create(sku:26,description:"Sal",prodType:"Materia Prima",unit_cost:99,lot:144,prod_time:1.242,stock:0,price:297)
prod.save
prod = Product.create(sku:50,description:"Arroz con leche",prodType:"Procesado",unit_cost:773,lot:350,prod_time:2.832,stock:0,price:2319)
prod.save
prod = Product.create(sku:54,description:"Hamburguesas",prodType:"Procesado",unit_cost:606,lot:1800,prod_time:0.860,stock:0,price:1818)
prod.save
prod = Product.create(sku:55,description:"Galletas Integrales",prodType:"Procesado",unit_cost:925,lot:950,prod_time:3.283,stock:0,price:2775)
prod.save
