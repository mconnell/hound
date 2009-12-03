class DomainObserver < ActiveRecord::Observer
  def after_build_profile(domain, transition)
    domain.send_later(:refresh)
  end
end
