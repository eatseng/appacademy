class LinksController < ApplicationController
  before_filter :verify_link_author

  def destroy
    @link = Link.find(params[:id])
    flash[:notice] = ["Link deleted"]
    @link.destroy
    redirect_to post_url(@link.post)
  end
end
