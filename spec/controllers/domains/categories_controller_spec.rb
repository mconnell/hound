require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Domains::CategoriesController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
  end

  describe "responding to GET index" do
    def do_get
      get :index, :domain_id => 'domainsapp.com'
    end

    describe "without logging in" do
      it "should not be successful" do
        do_get
        response.should_not be_success
      end

      it "should redirect_to the login page" do
        do_get
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        @domain = mock_model(Domain)
        Domain.stub!(:find_by_name!).and_return(@domain)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :index template" do
        do_get
        response.should render_template(:index)
      end

      it "should assign @active_navigation to be 'Domains'" do
        do_get
        assigns(:active_navigation).should == 'Domains'
      end
    end
  end

  describe "responding to POST create" do
    def do_post
      post :create, :domain_id => 'domainsapp.com', :category => { :name => 'sample category' }
    end

    describe "without logging in" do
      it "should not be successful" do
        do_post
        response.should_not be_success
      end

      it "should redirect_to the login page" do
        do_post
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        allow_message_expectations_on_nil
        @domain = mock_model(Domain)
        Domain.stub!(:find_by_name!).and_return(@domain)
        @domain.stub!(:categories)
        @domain.categories.stub!(:add)
      end

      it "should should add the categories" do
        @domain.categories.should_receive(:add)
        do_post
      end

      it "should redirect" do
        do_post
        response.should be_redirect
      end

    end
  end
end
