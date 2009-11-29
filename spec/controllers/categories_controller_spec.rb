require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CategoriesController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
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

      it "should redirect_to the login page" do
        do_get
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        @category = mock_model(Category)
        Category.stub!(:all).and_return([@category])
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :index template" do
        do_get
        response.should render_template(:index)
      end

      it "should assign @categories to the view" do
        do_get
        assigns(:categories).should == [@category]
      end

      it "should assign @active_navigation to be 'Categories'" do
        do_get
        assigns(:active_navigation).should == 'Categories'
      end
    end
  end

  describe "responding to GET show" do
    def do_get
      get :show, :id => '123'
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
        @category = mock_model(Category)
        Category.stub!(:find).and_return(@category)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :show template" do
        do_get
        response.should render_template(:show)
      end

      it "should find the category" do
        Category.should_receive(:find).with('123')
        do_get
      end

      it "should assign @categories to the view" do
        do_get
        assigns(:category).should == @category
      end

      it "should assign @active_navigation to be 'Categories'" do
        do_get
        assigns(:active_navigation).should == 'Categories'
      end
    end
  end
end
