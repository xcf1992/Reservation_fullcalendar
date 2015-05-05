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

ActiveRecord::Schema.define(version: 20150505180941) do

  create_table "clients", force: :cascade do |t|
    t.string   "identification"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "confirmation"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "occupied"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "zip_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "event_id"
    t.string   "tester"
    t.boolean  "showup"
    t.string   "comment"
  end

  create_table "test_result_files", force: :cascade do |t|
    t.string   "result_file_name"
    t.string   "result_content_type"
    t.integer  "result_file_size"
    t.datetime "result_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tests", force: :cascade do |t|
    t.string   "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "testId"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
