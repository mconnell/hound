class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_restricted_subdomain :through => :account

  def update_password(password, password_confirmation)
    valid?
    errors.add(:password, "must not be blank") if password.blank?
    errors.add(:password_confirmation, "must not be blank") if password_confirmation.blank?
    update_attributes(:password => password, :password_confirmation => password_confirmation) if errors.blank?
  end

end
