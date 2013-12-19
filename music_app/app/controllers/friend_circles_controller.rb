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
    sql = <<-SQL
      SELECT *
      FROM friend_circle_memberships
      INNER JOIN friend_circles
      ON friend_circles.id = friend_circle_memberships.friend_circle_id
      WHERE friend_circle_memberships.user_id = ?
    SQL
    circles_user_is_in = FriendCircle.find_by_sql([sql, current_user.id])
    @posts = circles_user_is_in.map {|circle| circle.posts}.first
    @posts ||= []
    render :feed
  end
end
