# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151108034600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_histories", force: :cascade do |t|
    t.integer  "summoner_id"
    t.float    "ward_avg"
    t.float    "gpm_avg"
    t.float    "cpm_avg"
    t.float    "kda_avg"
    t.float    "kill_participation"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "game_histories_users", id: false, force: :cascade do |t|
    t.integer "user_id",         null: false
    t.integer "game_history_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "summoner_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
