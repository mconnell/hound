class Google::AnalyticsReport < ActiveRecord::Base
  set_table_name "google_analytics_reports"

  belongs_to :domain

end
