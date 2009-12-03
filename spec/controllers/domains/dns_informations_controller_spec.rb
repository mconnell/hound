require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Domains::DnsInformationsController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
  end

  describe "responding to GET show" do
    def do_get
      get :show, :domain_id => 'domainsapp.com'
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

      it "should load a domain object" do
        Domain.should_receive(:find_by_name!)
        do_get
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :show template" do
        do_get
        response.should render_template(:show)
      end

      it "should assign @active_navigation to be 'Domains'" do
        do_get
        assigns(:active_navigation).should == 'Domains'
      end
    end
  end
end
