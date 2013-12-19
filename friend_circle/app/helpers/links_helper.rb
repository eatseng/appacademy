module LinksHelper
  def verify_link_author
    link = Link.find(params[:id])
    unless current_user == link.post.user
      flash[:errors] = ["User is not author of the link"]
      redirect_to post_url(link.post)
      return false
    end
    true
  end
end
