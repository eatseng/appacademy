class PostsController < ApplicationController
  before_filter :verify_logged_in
  before_filter :verify_post_author, :except => [:index, :new, :create, :show]

  def index
    @posts = current_user.posts
    render :index
  end

  def new
    @post = Post.new
    @circles = current_user.circles
    render :new
  end

  def create
    @post = Post.new(params[:post])
    filled_links = params[:links].values.select {|value| value['url']!=""}
    @post.links.new(filled_links)
    if @post.save
      flash[:notice] = ["Post created!"]
      redirect_to posts_url
    else
      flash.now[:errors] = [@post.errors.full_messages]
      @circles = current_user.circles
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def edit
    @post = Post.find(params[:id])
    @circles = current_user.circles
    @links = @post.links
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = ["Post updated!"]
      redirect_to posts_url
    else
      flash.now[:errors] = [@post.errors.full_messages]
      @circles = current_user.circles
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    flash[:notice] = ["Post deleted!"]
    @post.destroy
    redirect_to posts_url
  end

end
