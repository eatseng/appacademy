module FriendshipsHelper

  def can_friend?(out_friend_id, in_friend_id)
    Friendship.find_by_out_friend_id_and_in_friend_id(out_friend_id, in_friend_id).nil?
  end

  def can_unfriend?(out_friend_id, in_friend_id)
    !Friendship.find_by_out_friend_id_and_in_friend_id(out_friend_id, in_friend_id).nil?
  end
end
