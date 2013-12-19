class FriendCircleMembership < ActiveRecord::Base
  attr_accessible :user_id, :friend_circle_id

  belongs_to(
  :circle,
  :class_name => "FriendCircle",
  :foreign_key => :friend_circle_id,
  :primary_key => :id
  )

  belongs_to(
  :user_member,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  validates :user_id, :friend_circle_id, :presence => true

end
