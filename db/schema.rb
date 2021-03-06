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

ActiveRecord::Schema.define(:version => 20100101114311) do

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain"

  create_table "categories", :force => true do |t|
    t.integer  "account_id"
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["account_id"], :name => "index_categories_on_account_id"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "categories_domains", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "domain_id"
  end

  add_index "categories_domains", ["category_id"], :name => "index_categories_domains_on_category_id"
  add_index "categories_domains", ["domain_id"], :name => "index_categories_domains_on_domain_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns", :force => true do |t|
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dns_nameservers", :id => false, :force => true do |t|
    t.integer "dns_id"
    t.integer "nameserver_id"
  end

  create_table "domains", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "ascii_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "ga_tracking_code"
  end

  add_index "domains", ["account_id"], :name => "index_domains_on_account_id"
  add_index "domains", ["name"], :name => "index_domains_on_name"

  create_table "events", :force => true do |t|
    t.integer  "account_id"
    t.integer  "object_id"
    t.string   "object_class_name"
    t.string   "object_action"
    t.text     "object_attributes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["account_id"], :name => "index_events_on_account_id"

  create_table "google_analytics_reports", :force => true do |t|
    t.integer  "domain_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "visits"
    t.integer  "page_views"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nameservers", :force => true do |t|
    t.string   "host"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", :force => true do |t|
    t.integer  "dns_id"
    t.string   "host"
    t.string   "type"
    t.string   "value"
    t.integer  "preference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "records", ["dns_id"], :name => "index_records_on_dns_id"

  create_table "users", :force => true do |t|
    t.integer  "account_id"
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"

end
