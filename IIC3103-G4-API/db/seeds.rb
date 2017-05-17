# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#productos
prod = Product.create(sku:2,description:"Huevo",prodType:"Materia Prima",unit_cost:102,lot:150,prod_time:2.011,stock:0,price:120)
prod.save
prod = Product.create(sku:4,description:"Aceite de Maravilla",prodType:"Procesado",unit_cost:412,lot:200,prod_time:2.713,stock:0,price:480)
prod.save
prod = Product.create(sku:8,description:"Trigo",prodType:"Materia Prima",unit_cost:252,lot:100,prod_time:2.531,stock:0,price:300)
prod.save
prod = Product.create(sku:10,description:"Pan Marraqueta",prodType:"Procesado",unit_cost:1084,lot:900,prod_time:2.771,stock:0,price:1150)
prod.save
prod = Product.create(sku:14,description:"Cebada",prodType:"Procesado",unit_cost:296,lot:1750,prod_time:2.220,stock:0,price:380)
prod.save
prod = Product.create(sku:16,description:"Pasta de trigo",prodType:"Procesado",unit_cost:612,lot:1000,prod_time:2.493,stock:0,price:750)
prod.save
prod = Product.create(sku:20,description:"Cacao",prodType:"Materia Prima",unit_cost:172,lot:60,prod_time:1.955,stock:0,price:250)
prod.save
prod = Product.create(sku:26,description:"Sal",prodType:"Materia Prima",unit_cost:99,lot:144,prod_time:1.242,stock:0,price:160)
prod.save
prod = Product.create(sku:50,description:"Arroz con leche",prodType:"Procesado",unit_cost:773,lot:350,prod_time:2.832,stock:0,price:900)
prod.save
prod = Product.create(sku:54,description:"Hamburguesas",prodType:"Procesado",unit_cost:606,lot:1800,prod_time:0.860,stock:0,price:700)
prod.save
prod = Product.create(sku:55,description:"Galletas Integrales",prodType:"Procesado",unit_cost:925,lot:950,prod_time:3.283,stock:0,price:1100)
prod.save

#tuplas sku-grupo
sku = SkuGroup.create(sku:1,geoup:1)
sku.save
sku = SkuGroup.create(sku:1,geoup:3)
sku.save
sku = SkuGroup.create(sku:2,geoup:2)
sku.save
sku = SkuGroup.create(sku:2,geoup:6)
sku.save
sku = SkuGroup.create(sku:3,geoup:3)
sku.save
sku = SkuGroup.create(sku:3,geoup:5)
sku.save
sku = SkuGroup.create(sku:4,geoup:6)
sku.save
sku = SkuGroup.create(sku:4,geoup:8)
sku.save
sku = SkuGroup.create(sku:5,geoup:5)
sku.save
sku = SkuGroup.create(sku:6,geoup:6)
sku.save
sku = SkuGroup.create(sku:6,geoup:8)
sku.save
sku = SkuGroup.create(sku:6,geoup:2)
sku.save
sku = SkuGroup.create(sku:7,geoup:1)
sku.save
sku = SkuGroup.create(sku:7,geoup:3)
sku.save
sku = SkuGroup.create(sku:7,geoup:5)
sku.save
sku = SkuGroup.create(sku:7,geoup:7)
sku.save
sku = SkuGroup.create(sku:8,geoup:2)
sku.save
sku = SkuGroup.create(sku:8,geoup:6)
sku.save
sku = SkuGroup.create(sku:9,geoup:3)
sku.save
sku = SkuGroup.create(sku:9,geoup:5)
sku.save
sku = SkuGroup.create(sku:11,geoup:5)
sku.save
sku = SkuGroup.create(sku:12,geoup:6)
sku.save
sku = SkuGroup.create(sku:13,geoup:7)
sku.save
sku = SkuGroup.create(sku:13,geoup:1)
sku.save
sku = SkuGroup.create(sku:13,geoup:3)
sku.save
sku = SkuGroup.create(sku:14,geoup:2)
sku.save
sku = SkuGroup.create(sku:15,geoup:3)
sku.save
sku = SkuGroup.create(sku:15,geoup:5)
sku.save
sku = SkuGroup.create(sku:17,geoup:5)
sku.save
sku = SkuGroup.create(sku:18,geoup:6)
sku.save
sku = SkuGroup.create(sku:19,geoup:6)
sku.save
sku = SkuGroup.create(sku:19,geoup:8)
sku.save
sku = SkuGroup.create(sku:20,geoup:2)
sku.save
sku = SkuGroup.create(sku:20,geoup:6)
sku.save
sku = SkuGroup.create(sku:20,geoup:8)
sku.save
sku = SkuGroup.create(sku:22,geoup:1)
sku.save
sku = SkuGroup.create(sku:22,geoup:3)
sku.save
sku = SkuGroup.create(sku:22,geoup:5)
sku.save
sku = SkuGroup.create(sku:23,geoup:6)
sku.save
sku = SkuGroup.create(sku:23,geoup:7)
sku.save
sku = SkuGroup.create(sku:23,geoup:8)
sku.save
sku = SkuGroup.create(sku:23,geoup:1)
sku.save
sku = SkuGroup.create(sku:25,geoup:1)
sku.save
sku = SkuGroup.create(sku:25,geoup:3)
sku.save
sku = SkuGroup.create(sku:25,geoup:5)
sku.save
sku = SkuGroup.create(sku:25,geoup:7)
sku.save
sku = SkuGroup.create(sku:26,geoup:2)
sku.save
sku = SkuGroup.create(sku:26,geoup:6)
sku.save
sku = SkuGroup.create(sku:26,geoup:8)
sku.save
sku = SkuGroup.create(sku:27,geoup:6)
sku.save
sku = SkuGroup.create(sku:27,geoup:7)
sku.save
sku = SkuGroup.create(sku:27,geoup:8)
sku.save
sku = SkuGroup.create(sku:34,geoup:1)
sku.save
sku = SkuGroup.create(sku:38,geoup:7)
sku.save
sku = SkuGroup.create(sku:38,geoup:8)
sku.save
sku = SkuGroup.create(sku:39,geoup:1)
sku.save
sku = SkuGroup.create(sku:39,geoup:2)
sku.save
sku = SkuGroup.create(sku:40,geoup:2)
sku.save
sku = SkuGroup.create(sku:41,geoup:2)
sku.save
sku = SkuGroup.create(sku:41,geoup:3)
sku.save
sku = SkuGroup.create(sku:41,geoup:7)
sku.save
sku = SkuGroup.create(sku:42,geoup:8)
sku.save
sku = SkuGroup.create(sku:46,geoup:1)
sku.save
sku = SkuGroup.create(sku:47,geoup:7)
sku.save
sku = SkuGroup.create(sku:48,geoup:3)
sku.save
sku = SkuGroup.create(sku:49,geoup:1)
sku.save
sku = SkuGroup.create(sku:49,geoup:2)
sku.save
sku = SkuGroup.create(sku:49,geoup:3)
sku.save
sku = SkuGroup.create(sku:51,geoup:7)
sku.save
sku = SkuGroup.create(sku:52,geoup:3)
sku.save
sku = SkuGroup.create(sku:52,geoup:5)
sku.save
sku = SkuGroup.create(sku:52,geoup:7)
sku.save
sku = SkuGroup.create(sku:53,geoup:8)
sku.save
sku = SkuGroup.create(sku:56,geoup:5)
sku.save