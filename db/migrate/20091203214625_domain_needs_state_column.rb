class DomainNeedsStateColumn < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.string :state
    end
  end

  def self.down
    change_table :domains do |t|
      t.remove :state
    end
  end
end
