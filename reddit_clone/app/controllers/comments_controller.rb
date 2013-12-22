class CommentsController < ApplicationController
  before_filter :user_logged_in?

  def replies
    fail
    @comment = Comment.find(param[:id])
    render :repies
  end

  def create
    @link = Link.find(params[:link_id])
    comment = Comment.new(fill_params(params))
    if comment.save
      flash[:notice] = ["Comment created!"]
      redirect_to link_url(@link)
    else
      flash[:errors] = [comment.errors.full_messages]
      redirect_to link_url(@link)
    end
  end

  def show
    @link = Link.find(params[:link_id])
    @comment = Comment.new(replies_params(params))
    @parent_comment = Comment.find(params[:id])
  end


  def fill_params(params)
    params[:comment][:user_id] = current_user.id
    params[:comment][:comment_id] = params[:id] unless params[:comment][:comment_id]
    params[:comment][:link_id] = params[:link_id]
    params[:comment]
  end

  def replies_params(params)
    replies_params = {}
    replies_params[:user_id] = current_user.id
    replies_params[:link_id] = params[:link_id]
    replies_params[:comment_id] = params[:id]
    replies_params
  end
end
