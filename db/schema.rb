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

ActiveRecord::Schema.define(version: 20150702015531) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.integer  "pull_request",             null: false
    t.string   "repo",                     null: false
    t.string   "user",                     null: false
    t.string   "sha",                      null: false
    t.integer  "state",        default: 0
    t.text     "payload",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.string   "github_token"
    t.integer  "webhook_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "private"
  end

  add_index "repositories", ["name"], name: "index_repositories_on_name", unique: true, using: :btree

  create_table "repositories_users", id: false, force: :cascade do |t|
    t.integer "user_id",       null: false
    t.integer "repository_id", null: false
  end

  add_index "repositories_users", ["repository_id"], name: "index_repositories_users_on_repository_id", using: :btree
  add_index "repositories_users", ["user_id"], name: "index_repositories_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "image"
    t.string   "uid"
    t.string   "nickname"
    t.string   "token"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  create_table "violations", force: :cascade do |t|
    t.string   "filename",    null: false
    t.integer  "line_number", null: false
    t.integer  "build_id"
    t.text     "message",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "violations", ["build_id"], name: "index_violations_on_build_id", using: :btree

  add_foreign_key "violations", "builds"
end
