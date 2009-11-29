require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardsController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
  end

  describe "responding to GET show" do
    def do_get
      get :show
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
        @number_of_domains    = 123
        @number_of_categories = 456
        Domain.stub!(:count).and_return(@number_of_domains)
        Category.stub!(:count).and_return(@number_of_categories)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :show template" do
        do_get
        response.should render_template(:show)
      end

      it "should get a count of all the domains" do
        Domain.should_receive(:count)
        do_get
      end

      it "should get a count of all the categories" do
        Category.should_receive(:count)
        do_get
      end

      it "should assign the number_of_domains to the view" do
        do_get
        assigns(:number_of_domains).should == @number_of_domains
      end

      it "should assign the number_of_categories to the view" do
        do_get
        assigns(:number_of_categories).should == @number_of_categories
      end
    end

  end

end
