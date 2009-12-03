class Domains::DnsInformationsController < ApplicationController
  layout 'domain'

  before_filter :find_domain, :set_active_navigation

  def show
    respond_to do |format|
      format.html
    end
  end

  private
  def find_domain
    @domain = Domain.find_by_name!(params[:domain_id])
  end

  def set_active_navigation
    @active_navigation      = 'Domains'
    @active_sub_navigation  = 'DNS Information'
  end
end
