class Account < ActiveRecord::Base
  use_for_restricted_subdomains :by => :subdomain

  # associations
  has_one :user

  # attributes accessible on mass assignment
  attr_accessible :subdomain

  # validations
  validates_presence_of   :subdomain
  validates_length_of     :subdomain, :minimum => 2
  validates_format_of     :subdomain, :with => /^[a-z0-9]{1}[a-z0-9\-]*[a-z0-9]{1}$/i
  validates_uniqueness_of :subdomain
  validates_exclusion_of  :subdomain, :in => %w( www support mail )
end
