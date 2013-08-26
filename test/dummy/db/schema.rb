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

ActiveRecord::Schema.define(:version => 20130825160514) do

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "weirdy_wexception_occurrences", :force => true do |t|
    t.integer  "wexception_id"
    t.text     "backtrace"
    t.string   "backtrace_hash"
    t.datetime "happened_at"
    t.text     "data"
  end

  add_index "weirdy_wexception_occurrences", ["happened_at"], :name => "index_weirdy_wexception_occurrences_on_happened_at"
  add_index "weirdy_wexception_occurrences", ["wexception_id"], :name => "index_weirdy_wexception_occurrences_on_wexception_id"

  create_table "weirdy_wexceptions", :force => true do |t|
    t.string   "kind"
    t.string   "message"
    t.integer  "occurrences_count"
    t.integer  "state"
    t.datetime "first_happened_at"
    t.datetime "last_happened_at"
  end

  add_index "weirdy_wexceptions", ["kind", "message"], :name => "index_weirdy_wexceptions_on_kind_and_message"
  add_index "weirdy_wexceptions", ["last_happened_at"], :name => "index_weirdy_wexceptions_on_last_happened_at"
  add_index "weirdy_wexceptions", ["occurrences_count"], :name => "index_weirdy_wexceptions_on_occurrences_count"
  add_index "weirdy_wexceptions", ["state"], :name => "index_weirdy_wexceptions_on_state"

end
