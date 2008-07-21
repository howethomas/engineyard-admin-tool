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

ActiveRecord::Schema.define(:version => 41) do

  create_table "actions", :force => true do |t|
    t.integer  "server_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "message"
  end

  create_table "cdr", :force => true do |t|
    t.datetime "calldate",                                  :null => false
    t.string   "clid",        :limit => 80, :default => "", :null => false
    t.string   "src",         :limit => 80, :default => "", :null => false
    t.string   "dst",         :limit => 80, :default => "", :null => false
    t.string   "dcontext",    :limit => 80, :default => "", :null => false
    t.string   "channel",     :limit => 80, :default => "", :null => false
    t.string   "dstchannel",  :limit => 80, :default => "", :null => false
    t.string   "lastapp",     :limit => 80, :default => "", :null => false
    t.string   "lastdata",    :limit => 80, :default => "", :null => false
    t.integer  "duration",                  :default => 0,  :null => false
    t.integer  "billsec",                   :default => 0,  :null => false
    t.string   "disposition", :limit => 45, :default => "", :null => false
    t.integer  "amaflags",                  :default => 0,  :null => false
    t.string   "accountcode", :limit => 20, :default => "", :null => false
    t.string   "userfield",                 :default => "", :null => false
    t.string   "uniqueid",    :limit => 32, :default => "", :null => false
  end

  add_index "cdr", ["calldate"], :name => "calldate"
  add_index "cdr", ["dst"], :name => "dst"
  add_index "cdr", ["accountcode"], :name => "accountcode"

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "extension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.string   "mobile_number"
    t.boolean  "on_vacation"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "voicemail_pin"
    t.string   "password_reset_token"
    t.text     "availability_rules"
    t.boolean  "admin"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ivr_option"
    t.string   "caller_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setting_managers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  create_table "setting_overrides", :force => true do |t|
    t.integer  "setting_id"
    t.string   "type"
    t.integer  "foreign_id"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "value"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "human_name"
    t.boolean  "global_only"
  end

end
