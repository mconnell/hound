# Event model for capturing time-based events that occur during the
# operation of the app.

# Usage:
# Event.create(:object => object, :object_action => object_method_related_to_event)
class Event < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  # Specifc to this app, should be removed for pluginification
  acts_as_restricted_subdomain :through => :account

  named_scope :recent, :limit => 10, :order => 'created_at DESC'

  # Setter for object attributes, allows us to make the create action a
  # little more compact.
  def object=(object)
    attributes = object.attributes
    self.object_id         = attributes.delete('id')
    self.object_class_name = object.class.class_name
    self.object_attributes = attributes
  end

  def object_attributes
    # deserialize the attributes from the persistent store
    YAML.load(read_attribute(:object_attributes)).symbolize_keys!
  end
  memoize :object_attributes

end
