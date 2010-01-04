Formtastic::SemanticFormBuilder.default_text_field_size = nil

# Override the default behaviour of Formtastic so we can use
# default_text_field_size = nil without it randomly getting a
# bit upset.
Formtastic::SemanticFormBuilder.class_eval do
  def default_string_options(method, type) #:nodoc:
    column = @object.column_for_attribute(method) if @object.respond_to?(:column_for_attribute)

    if type == :numeric || column.nil? || column.limit.nil?
      { :size => Formtastic::SemanticFormBuilder.send(:class_variable_get, :@@default_text_field_size) }
    else
      { :maxlength => column.limit, :size => [column.limit, Formtastic::SemanticFormBuilder.send(:class_variable_get, :@@default_text_field_size)].compact.min }
    end
  end
end
