class Category < ActiveRecord::Base
  acts_as_restricted_subdomain :through => :account
  acts_as_tree :order => "name"

  # associations
  has_and_belongs_to_many :domains

  # named_scopes
  named_scope :find_by_name_and_parent_id, lambda { |name, parent_id|
    { :conditions => (
        parent_id.present? ? ['name = ? AND parent_id = ?', name, parent_id] : ['name = ? AND parent_id IS NULL', name]
        )
    }
  }

end
