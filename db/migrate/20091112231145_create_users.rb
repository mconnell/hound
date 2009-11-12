class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer  :account_id
      t.string   :email,                              :null => false
      t.string   :crypted_password,                   :null => false
      t.string   :password_salt,                      :null => false
      t.string   :persistence_token,                  :null => false
      t.string   :single_access_token,                :null => false
      t.string   :perishable_token,                   :null => false
      t.integer  :login_count,         :default => 0, :null => false
      t.integer  :failed_login_count,  :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string   :current_login_ip
      t.string   :last_login_ip

      t.timestamps
    end
    add_index :users, :account_id
  end

  def self.down
    remove_index :users, :account_id
    drop_table :users
  end
end
