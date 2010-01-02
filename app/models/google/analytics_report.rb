# Model used for capturing Google analytics data
# fetch_report_data is called in a before_create filter
# allowing the start_at and end_at dates to be modified
# before submitting a request to Google for data.
# eg.
# @domain.google_analytics_reports.create!(:start_at => 1.month.ago.beginning_of_day)
# will set the start_at prior to the report request being submitted.
class Google::AnalyticsReport < ActiveRecord::Base
  set_table_name "google_analytics_reports"

  belongs_to :domain

  before_create :fetch_report_data

  named_scope :interval, lambda { |start_at, end_at|
    {
      :conditions => ['start_at >= ? AND end_at <= ?', start_at, end_at],
      :order      => 'start_at ASC'
    }
  }

  # convenience methods for interval named_scope
  def self.last_month
    interval(1.month.ago.beginning_of_month, 1.month.ago.end_of_month)
  end

  def self.current_month
    interval(Time.now.beginning_of_month, Time.now.end_of_month)
  end

  private
  def fetch_report_data
    start_date = start_at || 1.day.ago.beginning_of_day
    end_date   = end_at   || 1.day.ago.end_of_day

    if domain.present? && domain.ga_tracking_code.present?

      Garb::Session.login('msn@markconnell.co.uk', 'password123')
      report = Garb::Report.new(Garb::Profile.first(domain.ga_tracking_code),
                                :start_date => start_date,
                                :end_date   => end_date)
      report.metrics :visits, :page_views
      result = report.results[0]

      self.start_at   = start_date
      self.end_at     = end_date
      self.visits     = result.present? ? result.visits    : 0
      self.page_views = result.present? ? result.pageviews : 0
    end
  end

end
