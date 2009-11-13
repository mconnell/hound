ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'dashboards', :action => 'show'

  map.resource :dashboard,    :only => [:show]
end
