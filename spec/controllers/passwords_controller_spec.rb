require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do

  before(:each) do
    controller.stub!(:current_subdomain).and_return(current_subdomain)
    request.session = {}
  end

  describe "responding to GET edit" do
    def do_get
      get :edit
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
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :edit template" do
        do_get
        response.should render_template(:edit)
      end
    end
  end

  describe "responding to PUT update" do
    def do_put
      put :update, :user => { :password => 'pass', :password_confirmation => 'pass' }
    end

    describe "without logging in" do
      it "should not be successful" do
        do_put
        response.should_not be_success
      end

      it "should redirect to the login page" do
        do_put
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        current_user.stub!(:update_password)
      end

      it "should attempt to update the current user's password" do
        current_user.should_receive(:update_password)
        do_put
      end

      describe "after successfully updating the user's password" do
        before(:each) do
          current_user.stub!(:update_password).and_return(true)
        end

        it "should flash a notice" do
          do_put
          flash[:notice].should be_present
        end

        it "should redirect to the account settings page" do
          do_put
          response.should redirect_to(account_settings_path)
        end
      end

      describe "after failing to update the user's password" do
        before(:each) do
          current_user.stub!(:update_password).and_return(false)
        end

        it "should re-render the :edit template" do
          do_put
          response.should render_template(:edit)
        end
      end
    end
  end
end
