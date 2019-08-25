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

ActiveRecord::Schema.define(version: 2019_08_25_163539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emails", force: :cascade do |t|
    t.bigint "sent_by_id"
    t.string "from"
    t.string "to"
    t.string "subject"
    t.text "blob"
    t.text "text_body"
    t.text "html_body"
    t.datetime "read_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_by_id"], name: "index_emails_on_sent_by_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stripe_charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
    t.datetime "sent_at"
    t.string "sent_to_email"
    t.string "token"
    t.index ["stripe_charge_id"], name: "index_invoices_on_stripe_charge_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "ip"
    t.string "country_code"
    t.string "country_name"
    t.string "region_code"
    t.string "region_name"
    t.string "city"
    t.string "zip_code"
    t.string "time_zone"
    t.string "metro_code"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "log_trackers", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "location_id"
    t.string "url"
    t.string "params"
    t.string "http_method"
    t.string "ip_address"
    t.string "user_agent"
    t.integer "ip_count"
    t.text "headers"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_log_trackers_on_location_id"
    t.index ["user_id"], name: "index_log_trackers_on_user_id"
  end

  create_table "service_addresses", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "zip"
    t.integer "frequency"
    t.datetime "last_service"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_service_addresses_on_user_id"
  end

  create_table "service_charges", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id"
    t.bigint "service_address_id"
    t.bigint "stripe_charge_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_address_id"], name: "index_service_charges_on_service_address_id"
    t.index ["stripe_charge_id"], name: "index_service_charges_on_stripe_charge_id"
    t.index ["user_id"], name: "index_service_charges_on_user_id"
  end

  create_table "service_items", force: :cascade do |t|
    t.bigint "service_job_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_count_fraction"
    t.integer "unit_cost_in_pennies"
    t.integer "cost_in_pennies"
    t.integer "position"
    t.index ["service_job_id"], name: "index_service_items_on_service_job_id"
  end

  create_table "service_jobs", force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "service_address_id"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "serviced_at"
    t.index ["invoice_id"], name: "index_service_jobs_on_invoice_id"
    t.index ["service_address_id"], name: "index_service_jobs_on_service_address_id"
  end

  create_table "stripe_cards", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id"
    t.boolean "default"
    t.string "name"
    t.string "customer_id"
    t.string "last_4"
    t.integer "exp_month"
    t.integer "exp_year"
    t.string "customer_error"
    t.datetime "removed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stripe_cards_on_user_id"
  end

  create_table "stripe_charges", force: :cascade do |t|
    t.string "token"
    t.bigint "stripe_card_id"
    t.integer "cost_in_pennies"
    t.string "payment_error"
    t.datetime "charged_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_card_id"], name: "index_stripe_charges_on_stripe_card_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone"
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
