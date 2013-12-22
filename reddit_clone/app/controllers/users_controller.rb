class UsersController < ApplicationController
  before_filter :user_logged_in?, :except => [:new, :create]

  def index
    @users = User.all
    render :index
  end

  def new
    render :new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = ["#{@user.email} created!"]
      log_in_user(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = ["#{@user.email} deleted!"]
    @user.destroy
    redirect_url users_url
  end

end
