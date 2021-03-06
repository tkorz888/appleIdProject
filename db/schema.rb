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

ActiveRecord::Schema.define(version: 20170316134810) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "login"
    t.string   "password"
    t.string   "mail"
    t.string   "mailpassword"
    t.string   "ask1"
    t.string   "answer1"
    t.string   "ask2"
    t.string   "answer2"
    t.string   "ask3"
    t.string   "answer3"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "birthday"
    t.string   "country"
    t.integer  "state"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "parent_user_id"
    t.string   "activate_url"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "login"
    t.string   "password_digest"
    t.integer  "state",           default: 0
    t.boolean  "is_admin",        default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "ancestry"
    t.string   "secret"
    t.index ["ancestry"], name: "index_users_on_ancestry", using: :btree
  end

end
