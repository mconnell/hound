class AddGaTrackingCodeToDomains < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.string  :ga_tracking_code
    end
  end

  def self.down
    change_table :domains do |t|
      t.remove  :ga_tracking_code
    end
  end
end
