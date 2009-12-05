class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :account_id
      t.integer :object_id
      t.string  :object_class_name
      t.string  :object_action
      t.text    :object_attributes

      t.timestamps
    end

    add_index :events, :account_id
  end

  def self.down
    remove_index :events, :account_id
    drop_table :events
  end
end
