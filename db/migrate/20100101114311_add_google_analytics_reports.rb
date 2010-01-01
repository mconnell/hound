class AddGoogleAnalyticsReports < ActiveRecord::Migration
  def self.up
    create_table :google_analytics_reports do |t|
      t.integer   :domain_id
      t.datetime  :start_at
      t.datetime  :end_at
      t.integer   :visits
      t.integer   :page_views

      t.timestamps
    end
  end

  def self.down
    drop_table :google_analytics_reports
  end
end
