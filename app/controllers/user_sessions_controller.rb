class UserSessionsController < ApplicationController

  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      respond_to do |format|
        format.html { redirect_back_or_default root_url }
      end
    else
      respond_to do |format|
       format.html { render :action => :new }
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    respond_to do |format|
      format.html { redirect_back_or_default root_url }
    end
  end

end
