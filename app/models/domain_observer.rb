class DomainObserver < ActiveRecord::Observer
  def after_build_profile(domain, transition)
    Event.create(:object => domain, :object_action => 'build_profile')
    domain.send_later(:refresh)
  end
end
