# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100102155909) do

  create_table "allocations", :force => true do |t|
    t.integer  "resource_id",     :null => false
    t.integer  "project_id",      :null => false
    t.datetime "allocation_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_limit", :default => 0
    t.boolean  "administrator",  :default => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "organisation_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days"
    t.datetime "due_date"
    t.string   "colour"
    t.boolean  "archive",          :default => false
    t.boolean  "include_weekends", :default => false
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.integer  "organisation_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources_teams", :id => false, :force => true do |t|
    t.integer "team_id"
    t.integer "resource_id"
  end

  add_index "resources_teams", ["resource_id"], :name => "index_resources_teams_on_resource_id"
  add_index "resources_teams", ["team_id", "resource_id"], :name => "index_resources_teams_on_team_id_and_resource_id", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "organisation_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organisation_id"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.boolean  "read_only",                 :default => false
  end

end
