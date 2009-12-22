class Domain < ActiveRecord::Base
  include IDN
  acts_as_restricted_subdomain :through => :account

  # Associations
  has_and_belongs_to_many :categories, :uniq => true, :extend => Extensions::DomainCategory
  has_one :dns
  has_many :events, :foreign_key => :object_id,
                    :conditions => ['object_class_name = ?', class_name],
                    :order => 'created_at DESC'

  # AR callbacks
  before_create :generate_ascii_name

  # Validations
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_length_of     :name, :within => 4..255
  validate                :name_components_are_valid

  # State_machine
  state_machine :state, :initial => :new do
    event :build_profile do
      transition :new => :building
    end
    event :make_active do
      transition :building => :active
    end

    state :building do
      def refresh
        dns.refresh
        make_active
      end
    end

    state :active do
      def refresh
        dns.refresh
      end
    end
  end

  # override the initializer to build an associated dns object if one doesn't
  # already exist for the domain.
  def initialize(*args)
    super
    build_dns if dns.blank?
  end

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
