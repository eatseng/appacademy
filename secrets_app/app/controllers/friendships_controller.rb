class FriendshipsController < ApplicationController
  def create
    params[:friendship] = {}
    params[:friendship][:in_friend_id] = params['friend_id']
    params[:friendship][:out_friend_id] = current_user.id
    @friendship = Friendship.new(params[:friendship])
    if @friendship.save
      flash[:messages] = ["friendship created"]
      render :json => @friendship
    else
      flash[:errors] = [@friendship.errors.full_messages]
      render :json => @user.errors.full_messages
      redirect_to users_url
    end
  end

  def destroy
    @friendship = Friendship
                  .find_by_out_friend_id_and_in_friend_id(current_user.id, params['friend_id'])
    @friendship.destroy
    head 200
  end
end
