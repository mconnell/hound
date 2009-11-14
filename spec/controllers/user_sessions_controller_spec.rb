require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do

  describe "responding to GET new" do
    def do_get
      get :new
    end

    before(:each) do
      @mock_user_session = mock_model(UserSession)
      UserSession.stub!(:new).and_return(@mock_user_session)
    end

    describe "without logging in" do
      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :new template" do
        do_get
        response.should render_template(:new)
      end

      it "should build a new UserSession object" do
        UserSession.should_receive(:new)
        do_get
      end

      it "should assign the new UserSession object to the view" do
        do_get
        assigns(:user_session).should == @mock_user_session
      end
    end

    describe "while being logged in" do
      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the :new template" do
        do_get
        response.should render_template(:new)
      end

      it "should build a new UserSession object" do
        UserSession.should_receive(:new)
        do_get
      end

      it "should assign the new UserSession object to the view" do
        do_get
        assigns(:user_session).should == @mock_user_session
      end
    end
  end

  describe "responding to POST create" do
    def do_post
      post :create, :user_session => { :email => 'test@houndapp.com', :password => 'pass', :password_confirmation => 'pass'}
    end

    before(:each) do
      @mock_user_session = mock_model(UserSession)
      UserSession.stub!(:new).and_return(@mock_user_session)
      @mock_user_session.stub!(:save)
    end

    describe "without being logged in" do
      it "should build a new UserSession with the params" do
        UserSession.should_receive(:new).with(
          'email' => 'test@houndapp.com', 'password' => 'pass', 'password_confirmation' => 'pass'
        )
        do_post
      end

      it "should should attempt to save the user session" do
        @mock_user_session.should_receive(:save)
        do_post
      end

      describe "after successfully saving the user session" do
        before(:each) do
          @mock_user_session.stub!(:save).and_return(true)
        end

        it "should flash a notice message" do
          do_post
          response.flash[:notice].should be_present
        end

        it "should redirect away from the login page" do
          do_post
          response.should be_redirect
        end
      end

      describe "after failing to save the user session" do
        before(:each) do
          @mock_user_session.stub!(:save).and_return(false)
        end

        it "should re-render the :new template" do
          do_post
          response.should render_template(:new)
        end
      end
    end

    describe "after logging in" do
      before(:each) do
        login
      end

      it "should build a new UserSession with the params" do
        UserSession.should_receive(:new).with(
          'email' => 'test@houndapp.com', 'password' => 'pass', 'password_confirmation' => 'pass'
        )
        do_post
      end

      it "should should attempt to save the user session" do
        @mock_user_session.should_receive(:save)
        do_post
      end

      describe "after successfully saving the user session" do
        before(:each) do
          @mock_user_session.stub!(:save).and_return(true)
        end

        it "should flash a notice message" do
          do_post
          response.flash[:notice].should be_present
        end

        it "should redirect away from the login page" do
          do_post
          response.should be_redirect
        end
      end

      describe "after failing to save the user session" do
        before(:each) do
          @mock_user_session.stub!(:save).and_return(false)
        end

        it "should re-render the :new template" do
          do_post
          response.should render_template(:new)
        end
      end
    end
  end

  describe "responding to DELETE destroy" do
    def do_delete
      delete :destroy
    end

    describe "without logging in" do
      it "should not be successful" do
        do_delete
        response.should_not be_success
      end

      it "should redirect to the new session path" do
        do_delete
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "after logging in" do
      before(:each) do
        login
        current_user_session.stub!(:destroy)
      end

      it "should flash a notice of success" do
        do_delete
        response.flash[:notice].should be_present
      end

      it "should destroy the current user session" do
        current_user_session.should_receive(:destroy)
        do_delete
      end

      it "should redirect away from the controller" do
        do_delete
        response.should be_redirect
      end
    end
  end

end
