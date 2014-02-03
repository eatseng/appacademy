class GistsController < ApplicationController
  before_filter :require_current_user!

  def index
    render :json => current_user.gists
  end

  def show
    @gist = Gist.find(params[:id])
    #render :json => @gist
  end

  def create
    params['gist']['user_id'] = current_user.id
    gist = Gist.new(params[:gist])
    if gist.save
      render :json => gist
    else
      render :json => {:error => "did not save"}, status: :unprocessable_entity
    end
  end
end
