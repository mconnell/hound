class PasswordsController < ApplicationController
  before_filter :set_active_navigation

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @current_user.update_password(params[:user][:password], params[:user][:password_confirmation])
      respond_to do |format|
        format.html do
          flash[:notice] = 'Password was successfully updated.'
          redirect_to account_settings_path
        end
      end
    else
      respond_to do |format|
        format.html { render :action => :edit }
      end
    end
  end

  private
  def set_active_navigation
    @active_navigation = 'Account Settings'
  end

end
