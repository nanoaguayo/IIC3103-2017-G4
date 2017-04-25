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

ActiveRecord::Schema.define(version: 20170425183904) do

  create_table "balances", force: :cascade do |t|
    t.string   "account"
    t.bigint   "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "supplier"
    t.string   "client"
    t.bigint   "grossValue"
    t.bigint   "iva"
    t.bigint   "totalValue"
    t.string   "state"
    t.datetime "payDate"
    t.string   "purchaseOrderId"
    t.string   "rejectionCause"
    t.string   "cancellationCause"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "sku"
    t.string   "ware_house_id"
    t.integer  "costs"
    t.integer  "stock"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "orderid"
    t.string   "channel"
    t.string   "delivery_date"
    t.string   "supplier"
    t.string   "client"
    t.string   "sku"
    t.integer  "quantity"
    t.integer  "dispatchedQuantity"
    t.integer  "unitPrice"
    t.datetime "deadline"
    t.string   "state"
    t.string   "rejectionCause"
    t.string   "cancellationCause"
    t.string   "notes"
    t.string   "billid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "originAccount"
    t.string   "destinationAccount"
    t.bigint   "amount"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
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
