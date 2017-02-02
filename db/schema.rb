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

ActiveRecord::Schema.define(version: 20170202213244) do

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "gender"
    t.date     "birth_date"
    t.integer  "education"
    t.boolean  "marital_status"
    t.integer  "children_count"
    t.string   "city"
    t.string   "zip_code"
    t.integer  "annual_income"
    t.integer  "client_importance"
    t.integer  "client_potential"
    t.string   "twitter_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "context"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.boolean  "watson_response"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "customer_id"
    t.index ["customer_id"], name: "index_messages_on_customer_id"
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string "category"
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "date"
    t.decimal  "amount"
    t.integer  "transaction_category_id"
    t.integer  "customer_id"
    t.index ["customer_id"], name: "index_transactions_on_customer_id"
    t.index ["transaction_category_id"], name: "index_transactions_on_transaction_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
