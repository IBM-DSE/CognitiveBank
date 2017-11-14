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

ActiveRecord::Schema.define(version: 20171114015447) do

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.integer  "age"
    t.integer  "education_code"
    t.integer  "investment"
    t.integer  "income"
    t.integer  "activity"
    t.float    "yrly_amt"
    t.float    "avg_daily_tx"
    t.integer  "yrly_tx"
    t.float    "avg_tx_amt"
    t.integer  "negtweets"
    t.string   "state"
    t.string   "education"
    t.text     "context"
    t.boolean  "churn_prediction"
    t.float    "churn_probability"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ml_scoring_service_id"
    t.string   "locale"
    t.index ["ml_scoring_service_id"], name: "index_customers_on_ml_scoring_service_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "fraud_transactions", force: :cascade do |t|
    t.integer "time"
    t.decimal "amount"
    t.float   "v1"
    t.float   "v2"
    t.float   "v3"
    t.float   "v4"
    t.float   "v5"
    t.float   "v6"
    t.float   "v7"
    t.float   "v8"
    t.float   "v9"
    t.float   "v10"
    t.float   "v11"
    t.float   "v12"
    t.float   "v13"
    t.float   "v14"
    t.float   "v15"
    t.float   "v16"
    t.float   "v17"
    t.float   "v18"
    t.float   "v19"
    t.float   "v20"
    t.float   "v21"
    t.float   "v22"
    t.float   "v23"
    t.float   "v24"
    t.float   "v25"
    t.float   "v26"
    t.float   "v27"
    t.float   "v28"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.boolean  "watson_response"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "customer_id"
    t.index ["customer_id"], name: "index_messages_on_customer_id"
  end

  create_table "ml_scoring_services", force: :cascade do |t|
    t.string   "name"
    t.string   "hostname"
    t.integer  "ldap_port"
    t.string   "username"
    t.string   "password"
    t.integer  "scoring_port"
    t.string   "deployment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "scoring_hostname"
  end

  create_table "ml_scorings", force: :cascade do |t|
    t.boolean  "prediction"
    t.float    "probability"
    t.string   "endpoint"
    t.string   "response"
    t.datetime "created_at"
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "date"
    t.decimal  "amount"
    t.integer  "transaction_category_id"
    t.integer  "customer_id"
    t.string   "category"
    t.index ["customer_id"], name: "index_transactions_on_customer_id"
    t.index ["transaction_category_id"], name: "index_transactions_on_transaction_category_id"
  end

  create_table "twitter_personalities", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "username"
    t.string   "personality"
    t.string   "values"
    t.string   "needs"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_twitter_personalities_on_customer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
