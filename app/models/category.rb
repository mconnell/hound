class Category < ActiveRecord::Base
  acts_as_restricted_subdomain :through => :account
  acts_as_tree :order => "name"

  # associations
  has_and_belongs_to_many :domains

end
