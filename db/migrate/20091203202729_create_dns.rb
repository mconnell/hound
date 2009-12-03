class CreateDns < ActiveRecord::Migration
  def self.up
    create_table :dns do |t|
      t.references :domain
      t.timestamps
    end
  end

  def self.down
    drop_table :dns
  end
end
