require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DomainsController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
  end

  def mock_domain(stubs = {})
    @mock_domain ||= mock_model(Domain, stubs)
  end

  describe "responding to GET index" do
    def do_get
      get :index
    end

    describe "without logging in" do
      it "should not be successful" do
        do_get
        response.should_not be_success
      end

      it "should redirect to the login page" do
        do_get
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        Domain.stub!(:all).and_return([mock_domain])
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'index' template" do
        do_get
        response.should render_template(:index)
      end

      it "should find domains" do
        Domain.should_receive(:all)
        do_get
      end

      it "should assign @domains to the view" do
        do_get
        assigns(:domains).should == [mock_domain]
      end

      it "should assign @active_navigation to be 'Domains'" do
        do_get
        assigns(:active_navigation).should == 'Domains'
      end
    end
  end

  describe "responding to GET show" do
    def do_get
      get :show, :id => 'domainsapp.com'
    end

    describe "without logging in" do
      it "should not be successful" do
        do_get
        response.should_not be_success
      end

      it "should redirect to the login page" do
        do_get
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        Domain.stub!(:find_by_name!).and_return(mock_domain)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'show' template" do
        do_get
        response.should render_template(:show)
      end

      it "should try and find a Domain" do
        Domain.should_receive(:find_by_name!).with('domainsapp.com')
        do_get
      end

      it "should assign the domain to the view" do
        do_get
        assigns(:domain).should == mock_domain
      end

      it "should assign @active_navigation to be 'Domains'" do
        do_get
        assigns(:active_navigation).should == 'Domains'
      end
    end
  end

  describe "responding to GET new" do
    def do_get
      get :new
    end

    describe "without logging in" do
      it "should not be successful" do
        do_get
        response.should_not be_success
      end

      it "should redirect to the login page" do
        do_get
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        Domain.stub!(:new).and_return(mock_domain)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'new' template" do
        do_get
        response.should render_template(:new)
      end

      it "should build a new domain object" do
        Domain.should_receive(:new)
        do_get
      end

      it "should assign the domain to the view" do
        do_get
        assigns(:domain).should == mock_domain
      end

      it "should assign @active_navigation to be 'Domains'" do
        do_get
        assigns(:active_navigation).should == 'Domains'
      end
    end
  end

  describe "responding to POST create" do
    def do_post
      post :create, :domain => {:name => 'domainsapp.com'}
    end

    describe "without logging in" do
      it "should not be successful" do
        do_post
        response.should_not be_success
      end

      it "should redirect to the login page" do
        do_post
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        Domain.stub!(:new).and_return(mock_domain)
        mock_domain.stub!(:build_profile)
      end

      it "should attempt to build a new domain" do
        Domain.should_receive(:new).with('name' => 'domainsapp.com')
        do_post
      end

      it "should attempt to save the domain" do
        mock_domain.should_receive(:build_profile)
        do_post
      end

      describe "when the domain is a valid object" do
        before(:each) do
          mock_domain.stub!(:build_profile).and_return(true)
        end

        it "should redirect to the domain's show page" do
          do_post
          response.should redirect_to(domain_path(mock_domain))
        end
      end

      describe "when the domain is not valid" do
        before(:each) do
          mock_domain.stub!(:build_profile).and_return(false)
        end

        it "should render the new action again" do
          do_post
          response.should render_template(:new)
        end
      end
    end
  end

end
