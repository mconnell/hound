ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'dashboards', :action => 'show'

  map.resource :dashboard,        :only => [:show]
  map.resource :user_session,     :only => [:new, :create, :destroy]
  map.resource :account_settings, :only => [:show] do |account_settings|
    account_settings.resource :password, :only => [:edit, :update]
  end
end
