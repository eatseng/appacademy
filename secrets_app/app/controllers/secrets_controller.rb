class SecretsController < ApplicationController
  def new
    @recipient = User.find(params[:user_id])
  end

  def create
    params[:secret][:author_id] = current_user.id
    @secret = Secret.new(params[:secret])
    if @secret.save
      flash[:messages] = ["secret saved"]
      #redirect_to user_url(params[:secret][:recipient_id])
      render :json => @secret
    else
      #flash.now[:errors] = [@secret.errors.full_messages]
      #render :new
      render :json => @secret.errors.full_messages
    end
  end
end

