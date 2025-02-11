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

ActiveRecord::Schema[8.0].define(version: 2025_02_10_230144) do
  create_table "expenditures", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year"
    t.integer "month"
    t.decimal "income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year"
    t.string "month"
    t.string "category"
    t.decimal "amount_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "experts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.string "gender"
    t.integer "experience"
    t.text "about"
    t.decimal "charges_per_session", precision: 10, scale: 2
    t.string "designation"
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "expenditures", "users", primary_key: "user_id"
  add_foreign_key "expenses", "users", primary_key: "user_id"
end
