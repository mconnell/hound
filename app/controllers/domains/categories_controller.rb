class Domains::CategoriesController < ApplicationController
  layout 'domain'

  before_filter :find_domain, :set_active_navigation

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def create
    @domain.categories.add(params[:category][:name])
    respond_to do |format|
      format.html { redirect_to @domain }
    end
  end

  private
  def find_domain
    @domain = Domain.find_by_name!(params[:domain_id])
  end

  def set_active_navigation
    @active_navigation = 'Domains'
  end
end
