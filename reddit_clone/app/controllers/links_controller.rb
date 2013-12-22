class LinksController < ApplicationController
  before_filter :user_logged_in?
  before_filter :verify_link_author, :only => [:edit, :destroy]

  def upvotes
    @link = Link.find(params[:link_id])
    @upvote = UserVote.new(vote_params(params, true))
    if @upvote.save
      flash[:notice] = ["@link.title upvoted!"]
      redirect_to link_url(@link)
    else
      flash[:errors] = ["Already voted on link!"]
      redirect_to link_url(@link)
    end
  end

  def downvotes
    @link = Link.find(params[:link_id])
    @upvote = UserVote.new(vote_params(params, false))
    if @upvote.save
      flash[:notice] = ["@link.title upvoted!"]
      redirect_to link_url(@link)
    else
      flash[:errors] = ["Already voted on link!"]
      redirect_to link_url(@link)
    end
  end

  def vote_params(params, upvote)
    vote_params = {}
    vote_params[:user_id] = current_user.id
    vote_params[:link_id] = params[:link_id]
    vote_params[:upvote] = upvote
    vote_params
  end

  def index
    @links = current_user.links
  end

  def new
    @link = Link.new
    @comment = Comment.new
  end

  def create
    params[:link][:user_id] = current_user.id
    @link = Link.new(params[:link])
    @comment = Comment.new(params[:comment])
    if !params[:comment][:body].empty?
      params[:comment][:user_id] = current_user.id
      @link.comments.build(params[:comment])
    end
    if @link.save
      flash[:notice] = ["#{@link.title} created!"]
      redirect_to subs_url
    else
      flash.now[:errors] = @link.errors.full_messages
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def show
    @link = Link.find(params[:id])
    @arr_comments = @link.comments_by_parent_id
  end

  def destroy
    @link = Link.find(params[:id])
    flash[:notice] = ["#{@link.title} is deleted"]
    @link.destroy
    redirect_to subs_url
  end
end
