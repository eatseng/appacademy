class SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(params[:user])
    if @user
      log_in_user(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end

  def destroy
    log_out_user(current_user)
    render :new
  end
end
