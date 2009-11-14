ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

# current_subdomain is automagically set when making a request via
# a subdomain.host call. Assume for all of our tests we have a
# current_subdomain in the db.
def current_subdomain
  @current_subdomain ||= Factory(:account)
end

# FIXME: Do something plugin-wise with this
# pull in the session method from the acts_as_restricted_subdomain otherwise
# session calls get a bit upset because it is expecting a single instance not
# an array
def session
  if((current_subdomain rescue nil))
    request.session[current_subdomain_symbol] ||= {}
    request.session[current_subdomain_symbol]
  else
    request.session
  end
end

def current_user(stubs = {})
  @current_user ||= mock_model(User, stubs)
end

def current_user_session(stubs = {}, user_stubs = {})
  @current_user_session ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
end

def login(session_stubs = {}, user_stubs = {})
  UserSession.stub!(:find).and_return(current_user_session(session_stubs, user_stubs))
end

def logout
  @current_user_session = nil
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end
