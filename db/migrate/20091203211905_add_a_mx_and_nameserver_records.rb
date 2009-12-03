class AddAMxAndNameserverRecords < ActiveRecord::Migration
  def self.up
    create_table :nameservers do |t|
      t.string   :host
      t.string   :ip_address

      t.timestamps
    end

    create_table :dns_nameservers, :id => false do |t|
      t.integer :dns_id
      t.integer :nameserver_id
    end

    # Other types of DNS record
    create_table :records do |t|
      t.integer  :dns_id
      t.string   :host
      t.string   :type
      t.string   :value
      t.integer  :preference

      t.timestamps
    end

    add_index :records, :dns_id
  end

  def self.down
    remove_index :records, :dns_id
    drop_table :records
    drop_table :nameservers
  end
end
