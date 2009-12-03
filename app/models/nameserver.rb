class Nameserver < ActiveRecord::Base
  has_and_belongs_to_many :dns, :join_table => "dns_nameservers", :class_name => 'Dns'
end
