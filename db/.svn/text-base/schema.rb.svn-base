# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "configurations", :force => true do |t|
    t.string   "cfg_key"
    t.string   "cfg_value"
    t.text     "cfg_value_txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examiners", :force => true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "name"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examiners", ["login"], :name => "UniqueLogin", :unique => true

  create_table "results", :force => true do |t|
    t.integer  "unit_of_study_id"
    t.string   "sid"
    t.string   "sname"
    t.string   "fname"
    t.string   "degree"
    t.integer  "calyear"
    t.integer  "semester"
    t.integer  "mark"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["unit_of_study_id", "sid"], :name => "UniqueUcodeSid", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "unit_of_studies", :force => true do |t|
    t.string   "ucode"
    t.string   "uname"
    t.integer  "no_student"
    t.integer  "complete"
    t.integer  "semester"
    t.integer  "year"
    t.integer  "examiner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unit_of_studies", ["ucode"], :name => "UniqueUcode", :unique => true
  add_index "unit_of_studies", ["examiner_id"], :name => "fk_unit_of_study_login"

  add_foreign_key "results", ["unit_of_study_id"], "unit_of_studies", ["id"], :name => "fk_result_ucode"

  add_foreign_key "unit_of_studies", ["examiner_id"], "examiners", ["id"], :name => "fk_unit_of_study_login"

end
