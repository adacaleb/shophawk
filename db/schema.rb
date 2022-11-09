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

ActiveRecord::Schema[7.0].define(version: 2022_11_07_194453) do
  create_table "histories", force: :cascade do |t|
    t.integer "hnew_balance"
    t.string "hlast_email"
    t.integer "checkedin"
    t.integer "checkedout"
    t.string "hpart_number"
    t.integer "turninginv_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turninginv_id"], name: "index_histories_on_turninginv_id"
  end

  create_table "turninginvs", force: :cascade do |t|
    t.string "part_number"
    t.string "description"
    t.integer "to_take"
    t.integer "balance"
    t.integer "remaining"
    t.integer "minumum"
    t.string "location"
    t.string "vendor"
    t.string "buyer"
    t.string "last_received"
    t.string "last_email"
    t.string "employee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
