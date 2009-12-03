module DomainCategoryExtension
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

class Domain < ActiveRecord::Base
  include IDN
  acts_as_restricted_subdomain :through => :account

  # Associations
  has_and_belongs_to_many :categories, :uniq => true, :extend => DomainCategoryExtension
  has_one :dns

  # AR callbacks
  before_create :generate_ascii_name

  # Validations
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_length_of     :name, :within => 4..255
  validate                :name_components_are_valid


  def to_param
    name
  end

  # is this domain name an international domain name?
  def idn?
    name != ascii_name ? true : false
  end

  private
  # validation method for checking if a component/label of a domain name is less than
  # the RFC specified limit of 63 characters
  def name_components_are_valid
    pieces = name.present? ? name.split('.') : nil
    if pieces.class == Array
      pieces.each do |label|
        if label.length > 63
          errors.add(:name, 'portions can be a max 63 characters in length')
        end
      end
    end
  end

  # Persist a copy of the name represented in ASCII from
  # eg. öl.pl has an ascii equivilent xn--l-0ga.pl
  def generate_ascii_name
    self.ascii_name = Idna.toASCII(name)
  end
end
