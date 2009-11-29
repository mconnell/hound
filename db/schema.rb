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

ActiveRecord::Schema.define(:version => 20091129154602) do

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

  create_table "domains", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "ascii_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["account_id"], :name => "index_domains_on_account_id"
  add_index "domains", ["name"], :name => "index_domains_on_name"

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
