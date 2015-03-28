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

ActiveRecord::Schema.define(version: 20150328162304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.integer  "pull_request",                     null: false
    t.string   "repo",                             null: false
    t.string   "user",                             null: false
    t.string   "sha",                              null: false
    t.string   "state",        default: "pending", null: false
    t.text     "payload",                          null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "violations", force: :cascade do |t|
    t.string   "filename",   null: false
    t.integer  "line",       null: false
    t.integer  "build_id"
    t.text     "message",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "violations", ["build_id"], name: "index_violations_on_build_id", using: :btree

  add_foreign_key "violations", "builds"
end
