class FavoritesController < ApplicationController
  def index
  end

  def create
    params['favorite']['user_id'] = current_user.id
    favorite = Favorite.new(params[:favorite])
    if favorite.save
      p favorite
      render :json => favorite
    else
      render :json => {error: "invalid input"}, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
    render :json => favorite
  end
end
