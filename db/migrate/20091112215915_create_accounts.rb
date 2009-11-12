class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :subdomain
      t.timestamps
    end
    add_index :accounts, :subdomain
  end

  def self.down
    remove_index :accounts, :subdomain
    drop_table :accounts
  end
end
