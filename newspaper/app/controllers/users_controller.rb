class UsersController < ApplicationController
  before_filter :verify_user_logged_in?, :except => [:new, :create]

  def view_subscription
    @newspapers = Newspaper.all
    @subscriptions = Subscription.where("user_id == ?", current_user.id)
  end

  def add_subscription
    @newspapers = Newspaper.all
    params[:subscription][:user_id] = current_user.id
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save
      flash[:notice] = [params[:newspaper][:title] + " Suscribed!"]
      @subscriptions = Subscription.where("user_id == ?", current_user.id)
      redirect_to sub_url
    else
      flash.now[:errors] = [@subscription.errors.full_messages]
      @subscriptions = Subscription.where("user_id == ?", current_user.id)
      render :view_subscription
    end
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = ["#{@user.email} created!"]
      log_in!(@user)
      redirect_to sub_url
    else
      flash.now[:errors] = [@user.errors.full_messages]
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    flash[:notice] = ["#{@user.email} deleted!"]
    @user.destroy
    redirect_to users_url
  end
end
