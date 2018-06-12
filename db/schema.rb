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

ActiveRecord::Schema.define(version: 2018_06_01_235701) do

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "info", default: "A very cool game indeed!"
    t.index ["slug"], name: "index_games_on_slug"
  end

  create_table "runcats", force: :cascade do |t|
    t.string "category", null: false
    t.text "rules", null: false
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_runcats_on_category"
    t.index ["game_id"], name: "index_runcats_on_game_id"
  end

  create_table "speedruns", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.date "date_finished", null: false
    t.integer "runcat_id"
    t.text "run_notes"
    t.boolean "is_valid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "run_time_h", default: 99, null: false
    t.integer "run_time_m", default: 59, null: false
    t.integer "run_time_s", default: 59, null: false
    t.index ["game_id"], name: "index_speedruns_on_game_id"
    t.index ["runcat_id"], name: "index_speedruns_on_runcat_id"
    t.index ["user_id"], name: "index_speedruns_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
