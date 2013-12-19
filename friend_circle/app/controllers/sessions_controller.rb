class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:email],
      params[:user][:password]
      )
    if @user
      login!(@user)
      flash[:notice] = ["#{@user.email} logged in"]
      redirect_to friend_circles_url
    else
      flash[:errors] = ["Wrong User or Password"]
      redirect_to new_session_url
    end
  end

  def destroy
    flash[:notice] = ["#{current_user.email} logged out"]
    logout!
    redirect_to new_session_url
  end
end
