class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    flash[:notice] = "Link deleted"
    @link.destroy
    redirect_to post_url(@post)
  end
end
