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

ActiveRecord::Schema.define(version: 2024_04_23_221234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_snapshots", force: :cascade do |t|
    t.bigint "building_id"
    t.date "snapshot_date"
    t.integer "total_cost"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_snapshots_on_building_id"
    t.index ["snapshot_date"], name: "index_building_snapshots_on_snapshot_date"
    t.index ["status"], name: "index_building_snapshots_on_status"
  end

  create_table "buildings", force: :cascade do |t|
    t.bigint "contractor_id"
    t.string "name"
    t.string "address"
    t.integer "total_budget"
    t.integer "total_cost"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contractor_id"], name: "index_buildings_on_contractor_id"
    t.index ["status"], name: "index_buildings_on_status"
    t.index ["total_budget"], name: "index_buildings_on_total_budget"
    t.index ["total_cost"], name: "index_buildings_on_total_cost"
  end

  create_table "contractors", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elements", force: :cascade do |t|
    t.bigint "room_id"
    t.string "element_type"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_type"], name: "index_elements_on_element_type"
    t.index ["room_id"], name: "index_elements_on_room_id"
  end

  create_table "room_snapshots", force: :cascade do |t|
    t.bigint "room_id"
    t.date "snapshot_date"
    t.integer "total_cost"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_snapshots_on_room_id"
    t.index ["snapshot_date"], name: "index_room_snapshots_on_snapshot_date"
    t.index ["status"], name: "index_room_snapshots_on_status"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "building_id"
    t.string "room_type"
    t.integer "total_budget"
    t.integer "total_cost"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_rooms_on_building_id"
    t.index ["status"], name: "index_rooms_on_status"
    t.index ["total_budget"], name: "index_rooms_on_total_budget"
    t.index ["total_cost"], name: "index_rooms_on_total_cost"
  end

  add_foreign_key "building_snapshots", "buildings"
  add_foreign_key "buildings", "contractors"
  add_foreign_key "elements", "rooms"
  add_foreign_key "room_snapshots", "rooms"
  add_foreign_key "rooms", "buildings"
end
