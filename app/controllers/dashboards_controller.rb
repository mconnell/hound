class DashboardsController < ApplicationController

  before_filter :set_active_navigation

  def show
    respond_to do |format|
      format.html
    end
  end

  private
  def set_active_navigation
    @active_navigation = 'Dashboard'
  end

end
