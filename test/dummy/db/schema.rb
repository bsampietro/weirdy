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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130904012559) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "weirdy_wexception_occurrences", :force => true do |t|
    t.integer  "wexception_id"
    t.text     "message"
    t.text     "backtrace"
    t.datetime "happened_at"
    t.text     "data"
  end

  add_index "weirdy_wexception_occurrences", ["wexception_id"], :name => "index_weirdy_wexception_occurrences_on_wexception_id"

  create_table "weirdy_wexceptions", :force => true do |t|
    t.string   "kind"
    t.text     "last_message"
    t.integer  "occurrences_count"
    t.integer  "state"
    t.text     "raised_in"
    t.datetime "first_happened_at"
    t.datetime "last_happened_at"
  end

  add_index "weirdy_wexceptions", ["kind", "raised_in"], :name => "index_weirdy_wexceptions_on_kind_and_raised_in"
  add_index "weirdy_wexceptions", ["state", "last_happened_at"], :name => "index_weirdy_wexceptions_on_state_and_last_happened_at"
  add_index "weirdy_wexceptions", ["state", "occurrences_count"], :name => "index_weirdy_wexceptions_on_state_and_occurrences_count"

end
