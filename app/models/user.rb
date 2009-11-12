class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_restricted_subdomain :through => :account

  # validations
  validates_presence_of :account

end
