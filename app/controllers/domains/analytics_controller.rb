class Domains::AnalyticsController < ApplicationController
  layout 'domain'

  before_filter :find_domain, :set_active_navigation

  def show

    # FIXME: This really needs to be refactored..
    unless @domain.google_analytics_reports.last_30_days.empty?
      @last_30_days_visits = returning [] do |values|
        @domain.google_analytics_reports.last_30_days.each do |report|
          values << report.visits
        end
      end

      @first_day = @domain.google_analytics_reports.last_30_days.first.start_at
      @last_day = @domain.google_analytics_reports.last_30_days.last.start_at

      @total_visits     = @domain.google_analytics_reports.last_30_days.sum('visits')
      @total_page_views = @domain.google_analytics_reports.last_30_days.sum('page_views')
    end

    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @domain.update_ga_tracking_code(params[:domain][:ga_tracking_code])
      respond_to do |format|
        format.html {
          flash[:notice] = "Analytics tracking code updated"
          redirect_to domain_analytics_path(@domain)
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = "An error occurred while saving"
          render :action => :edit
        }
      end
    end
  end

  private
  def find_domain
    @domain = Domain.find_by_name!(params[:domain_id])
  end

  def set_active_navigation
    @active_navigation      = 'Domains'
    @active_sub_navigation  = 'Analytics'
  end
end
