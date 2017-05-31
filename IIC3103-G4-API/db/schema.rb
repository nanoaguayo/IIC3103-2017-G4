# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170531012838) do

  create_table "balances", force: :cascade do |t|
    t.string   "account"
    t.bigint   "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "proveedor"
    t.string   "cliente"
    t.integer  "bruto",      limit: 8
    t.integer  "iva",        limit: 8
    t.integer  "total",      limit: 8
    t.string   "estado"
    t.string   "oc"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "__v"
    t.string   "_id"
  end

  create_table "produced_orders", force: :cascade do |t|
    t.string   "sku"
    t.integer  "cantidad"
    t.string   "oc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "sku"
    t.string   "description"
    t.integer  "cost"
    t.integer  "lot"
    t.integer  "price"
    t.string   "ptype"
    t.integer  "ptime"
    t.integer  "proyected"
    t.integer  "stock"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "_id"
    t.string   "canal"
    t.datetime "fechaEntrega"
    t.string   "proveedor"
    t.string   "cliente"
    t.string   "sku"
    t.integer  "cantidad"
    t.integer  "cantidadDespachada"
    t.integer  "precioUnitario"
    t.datetime "deadline"
    t.string   "estado"
    t.string   "rechazo"
    t.string   "anulacion"
    t.string   "notas"
    t.string   "billid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "fechaDespachos"
    t.integer  "__v"
  end

  create_table "sku_groups", force: :cascade do |t|
    t.integer  "sku"
    t.integer  "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sku_ingridients", force: :cascade do |t|
    t.integer  "sku"
    t.integer  "ingridient"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "origen"
    t.string   "destino"
    t.integer  "monto"
    t.integer  "__v"
    t.string   "_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ware_houses", force: :cascade do |t|
    t.integer  "usedspace"
    t.integer  "totalspace"
    t.boolean  "reception"
    t.boolean  "dispatch"
    t.boolean  "pulmon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
