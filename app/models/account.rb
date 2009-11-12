class Account < ActiveRecord::Base
  use_for_restricted_subdomains :by => :subdomain

  validates_presence_of :subdomain
  validates_length_of   :subdomain, :minimum => 2
  validates_format_of   :subdomain, :with => /^[a-z0-9]{1}[a-z0-9\-]*[a-z0-9]{1}$/i
end
