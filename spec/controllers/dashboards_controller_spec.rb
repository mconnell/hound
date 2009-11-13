require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardsController do

  describe "responding to GET show" do
    def do_get
      get :show
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the :show template" do
      do_get
      response.should render_template(:show)
    end
  end

end
