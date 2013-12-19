module PostsHelper
  def verify_author
    post = Post.find(params[:id])
    unless current_user == post.user
      flash[:errors] = ["User is not author of the post"]
      redirect_to post_url(post)
      return false
    end
    true
  end
end
