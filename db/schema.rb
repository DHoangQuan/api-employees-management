# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_29_102137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "display_name", null: false
    t.string "email"
    t.string "phone_number"
    t.string "address1"
    t.string "address2"
    t.string "tax"
    t.string "website"
    t.string "name_by_print_on_checks"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "name"], name: "index_companies_on_id_and_name"
  end

  create_table "rate_settings", force: :cascade do |t|
    t.string "wkt_uuid", null: false
    t.bigint "rate_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wkt_uuid"], name: "index_rate_settings_on_wkt_uuid"
  end

  create_table "rates", force: :cascade do |t|
    t.float "internal_regular"
    t.float "internal_ot"
    t.float "external_regular"
    t.float "external_ot"
    t.float "holiday_rate"
    t.integer "status", default: 0, null: false, comment: "[0: current, 1:past]"
    t.string "type", null: false
    t.bigint "resource_id", null: false
    t.bigint "company_id", comment: "Check if user rates of which company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "resource_id"], name: "index_rates_on_type_and_resource_id"
  end

  create_table "user_companies", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "company_id"], name: "index_user_companies_on_user_id_and_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "phone_number"
    t.string "title"
    t.string "display_name", null: false
    t.string "name_by_print_on_checks"
    t.text "note"
    t.integer "role", null: false, comment: "[0: supper_admin, 1:admin, 2: manager, 3: employee]"
    t.string "address1"
    t.string "address2"
    t.boolean "allow_login", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id", "display_name", "email", "phone_number"], name: "index_users_on_id_and_display_name_and_email_and_phone_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeks", force: :cascade do |t|
    t.date "from_date"
    t.date "to_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_date"], name: "index_weeks_on_from_date"
  end

  create_table "working_times", comment: "this table is used for user working time and default working time", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "display_name"
    t.string "monday"
    t.string "tuesday"
    t.string "wednesday"
    t.string "thursday"
    t.string "friday"
    t.string "saturday"
    t.string "sunday"
    t.float "total_hours"
    t.float "i_reg_money"
    t.float "i_ot_money"
    t.float "e_reg_money"
    t.float "e_ot_money"
    t.text "note"
    t.bigint "company_id", null: false
    t.bigint "user_id"
    t.bigint "rate_id"
    t.bigint "week_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["display_name", "uuid"], name: "index_working_times_on_display_name_and_uuid"
  end

end
