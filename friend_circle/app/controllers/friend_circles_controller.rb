class FriendCirclesController < ApplicationController
  before_filter :verify_logged_in

  def index
    @circles = current_user.circles
    render :index
  end

  def new
    @circle = FriendCircle.new
    @users = User.where("email != ?", current_user.email)
    render :new
  end

  def create
    @circle = FriendCircle.new(params[:circle])
    if @circle.save
      flash[:notice] = ["#{@circle.name} created!"]
      redirect_to friend_circles_url
    else
      flash.now[:errors] = [@circle.errors.full_messages]
      render :new
    end
  end

  def show
    @circle = FriendCircle.find(params[:id])
    render :show
  end

  def edit
    @circle = FriendCircle.find(params[:id])
    @users = User.where("email != ?", current_user.email)
    render :edit
  end

  def update
    @circle = FriendCircle.find(params[:id])
    if @circle.update_attributes(params[:circle])
      flash[:notice] = ["#{@circle.name} updated!"]
      redirect_to friend_circles_url
    else
      flash.now[:errors] = [@circle.errors.full_messages]
      render :edit
    end
  end

  def destroy
    @circle = FriendCircle.find(params[:id])
    flash[:notice] = ["#{@circle.name} deleted!"]
    @circle.destroy
    redirect_to friend_circles_url
  end

  def feed
    friend_circles = FriendCircleMembership
                      .where("user_id = ?", current_user.id)
                      .map {|membership| membership.circle}
    @posts = friend_circles
              .select{|circle| !circle.nil?}
              .map {|circle| circle.posts}
              .flatten
    @posts ||= []
    render :feed
  end
end
