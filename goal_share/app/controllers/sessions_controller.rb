class SessionsController < ApplicationController
  def create
    @user = User.find_by_credential(params)
    if @user
      flash[:notice] = ["Welcome #{@user.email}"]
      log_in!(@user)
      redirect_to goals_url
    else
      flash.now[:errors] = ["Incorrect Username or Password"]
      render :new
    end
  end

  def destroy
    log_out!(current_user)
    flash[:notice] = ["User logged out"]
    redirect_to new_session_url
  end
end
