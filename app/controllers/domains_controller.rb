class DomainsController < ApplicationController
  before_filter :set_active_navigation

  def index
    @domains = Domain.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @domain = Domain.find_by_name!(params[:id])
    @active_sub_navigation = 'Overview'
    respond_to do |format|
      format.html { render :layout => 'domain' }
    end
  end

  def new
    @domain = Domain.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      respond_to do |format|
        format.html { redirect_to domain_path(@domain) }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
      end
    end
  end

  def destroy
    @domain = Domain.find_by_name!(params[:id])
    @domain.destroy
    flash[:notice] = "Domain deleted."
    respond_to do |format|
      format.html { redirect_to domains_path }
    end
  end

  private
  def set_active_navigation
    @active_navigation = 'Domains'
  end
end
