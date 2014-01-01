class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credential(params)
    if @user
      flash[:notice] = ["#{@user.email} logged in!"]
      log_in!(@user)
      redirect_to sub_url
    else
      flash[:errors] = ["Invalid email or password"]
      redirect_to new_session_url
    end
  end

  def destroy
    log_out!
    flash[:notice] = ["User logged out"]
    redirect_to new_session_url
  end
end
