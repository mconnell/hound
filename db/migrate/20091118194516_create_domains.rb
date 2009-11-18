class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.integer :account_id
      t.string  :name
      t.string  :ascii_name

      t.timestamps
    end

    add_index :domains, :account_id
    add_index :domains, :name
  end

  def self.down
    remove_index :domains, :account_id
    remove_index :domains, :name
    drop_table :domains
  end
end
