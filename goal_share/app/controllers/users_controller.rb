class UsersController < ApplicationController
  before_filter :verify_user, :except => [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = ["#{@user.email} created!"]
      log_in!(@user)
      redirect_to goals_url
    else
      flash.now[:errors] = [@user.errors.full_messages]
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = ["#{@user.email} deleted!"]
    @user.destroy
    redirect_to new_user_url
  end
end
