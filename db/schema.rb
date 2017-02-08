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

ActiveRecord::Schema.define(version: 20170208021608) do

  create_table "endpoints", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "ip",         limit: 15, null: false
    t.integer  "port",       limit: 2,  null: false, unsigned: true
    t.integer  "task_id",               null: false, unsigned: true
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["task_id"], name: "index_endpoints_on_task_id", using: :btree
  end

  create_table "tasks", unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "arn",        null: false
    t.string   "repository", null: false
    t.integer  "pr_number",  null: false, unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository", "pr_number"], name: "index_tasks_on_repository_and_pr_number", unique: true, using: :btree
  end

  add_foreign_key "endpoints", "tasks"
end
