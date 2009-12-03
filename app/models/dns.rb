class Dns < ActiveRecord::Base
  # associations
  belongs_to :domain

  # validations
  validates_presence_of :domain_id
end
