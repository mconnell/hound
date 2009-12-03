class Dns < ActiveRecord::Base
  # associations
  belongs_to              :domain
  has_and_belongs_to_many :nameservers, :extend => Extensions::NameserverAssociation
  has_many                :a_records,   :extend => Extensions::ARecordAssociation
  has_many                :mx_records,  :extend => Extensions::MxRecordAssociation

  # validations
  validates_presence_of :domain_id
end
