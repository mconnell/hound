class Domain < ActiveRecord::Base
  include IDN
  acts_as_restricted_subdomain :through => :account

  # AR callbacks
  before_create :generate_ascii_name

  # Validations
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_length_of     :name, :within => 4..255
  validate                :name_components_are_valid


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
