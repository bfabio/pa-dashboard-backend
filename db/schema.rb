# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_15_092429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: :cascade do |t|
    t.string "hostname", null: false
    t.string "token", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hostname"], name: "index_api_tokens_on_hostname"
    t.index ["token"], name: "index_api_tokens_on_token"
  end

  create_table "reports", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "date", null: false
    t.string "hostname", null: false
    t.text "description", null: false
    t.string "doc_url"
    t.integer "category", null: false
    t.integer "severity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_reports_on_date"
    t.index ["hostname"], name: "index_reports_on_hostname"
    t.index ["key", "hostname"], name: "index_reports_on_key_and_hostname", unique: true
  end

end
