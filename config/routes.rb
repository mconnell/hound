ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'dashboards', :action => 'show'

  map.resource :dashboard,        :only => [:show]
  map.resource :user_session,     :only => [:new, :create, :destroy]
  map.resource :account_settings, :only => [:show] do |account_settings|
    account_settings.resource :password, :only => [:edit, :update]
    account_settings.resource :email,    :only => [:edit, :update]
  end

  map.resources :domains, :requirements => { :id => %r([^/;,?]+) } do |domain|
    domain.resources  :categories,
                      :namespace => "domains/",
                      :requirements => { :domain_id => %r([^/;,?]+) }

    domain.resource   :dns_information,
                      :namespace => "domains/",
                      :requirements => { :domain_id => %r([^/;,?]+) }
  end

  map.resources :categories, :only => [:index, :show]
end
