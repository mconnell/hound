ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'dashboards', :action => 'show'

  map.resource :dashboard,    :only => [:show]
  map.resource :user_session, :only => [:new, :create, :destroy]
end
