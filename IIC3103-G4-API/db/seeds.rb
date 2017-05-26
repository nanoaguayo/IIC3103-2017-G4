# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#productos
Product.delete_all
prod = Product.create(proyected:0, sku:2,description:"Huevo",ptype:"Materia Prima",cost:102,lot:150,ptime:2.011,stock:5000,price:306)
prod.save
prod = Product.create(proyected:0, sku:4,description:"Aceite de Maravilla",ptype:"Procesado",cost:412,lot:200,ptime:2.713,stock:0,price:1236)
prod.save
prod = Product.create(proyected:0, sku:8,description:"Trigo",ptype:"Materia Prima",cost:252,lot:100,ptime:2.531,stock:0,price:756)
prod.save
prod = Product.create(proyected:0, sku:10,description:"Pan Marraqueta",ptype:"Procesado",cost:1084,lot:900,ptime:2.771,stock:0,price:3232)
prod.save
prod = Product.create(proyected:0, sku:14,description:"Cebada",ptype:"Procesado",cost:296,lot:1750,ptime:2.220,stock:0,price:888)
prod.save
prod = Product.create(proyected:0, sku:16,description:"Pasta de trigo",ptype:"Procesado",cost:612,lot:1000,ptime:2.493,stock:0,price:1836)
prod.save
prod = Product.create(proyected:0, sku:20,description:"Cacao",ptype:"Materia Prima",cost:172,lot:60,ptime:1.955,stock:0,price:516)
prod.save
prod = Product.create(proyected:0, sku:26,description:"Sal",ptype:"Materia Prima",cost:99,lot:144,ptime:1.242,stock:0,price:297)
prod.save
prod = Product.create(proyected:0, sku:50,description:"Arroz con leche",ptype:"Procesado",cost:773,lot:350,ptime:2.832,stock:0,price:2319)
prod.save
prod = Product.create(proyected:0, sku:54,description:"Hamburguesas",ptype:"Procesado",cost:606,lot:1800,ptime:0.860,stock:0,price:1818)
prod.save
prod = Product.create(proyected:0, sku:55,description:"Galletas Integrales",ptype:"Procesado",cost:925,lot:950,ptime:3.283,stock:0,price:2775)
prod.save

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
