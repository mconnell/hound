module Extensions
  module DomainCategory
    # Association extension for the @domain.categories association
    # usage: @domain.categories.add('category name')
    # The method will attempt to find an existing model with the name
    # and add it to this domain or will create a new category.
    def add(category_name)
      names = category_name.split('/')
      names.each_with_index do |name, index|
        parent = ( index > 0 ? find_by_name(names[index-1]) : nil)
        parent_id = parent.id if parent.present?

        if category = find_by_name_and_parent_id(name, parent_id).present?
        elsif ((category = Category.find_by_name_and_parent_id(name, parent_id)) && category.present?)
          self << category.first
        else
          self.create(:name => name, :parent_id => parent_id)
        end
      end
    end
  end
end
