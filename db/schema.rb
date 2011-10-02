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

ActiveRecord::Schema.define(:version => 20111002144431) do

  create_table "checkups", :force => true do |t|
    t.boolean  "healthy"
    t.float    "name_lookup_time"
    t.float    "start_transfer_time"
    t.float    "total_time"
    t.integer  "downloaded_bytes"
    t.integer  "retries_used"
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkups", ["environment_id"], :name => "index_checkups_on_environment_id"

  create_table "environments", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "timeout"
    t.integer  "retries"
    t.integer  "between_retries_wait"
    t.string   "ip_relay_commands"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "environments", ["site_id"], :name => "index_environments_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
