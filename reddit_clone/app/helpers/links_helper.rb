module LinksHelper

  def verify_link_author
    link = Link.find(params[:id])
    unless current_user == link.user
      flash[:errors] = ["Current user is not author of the link!"]
      redirect_to link_url(link)
      return false
    end
    true
  end
end
