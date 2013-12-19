class PostShare < ActiveRecord::Base
  attr_accessible :post_id, :friend_circle_id

  belongs_to(
  :post,
  :class_name => "Post",
  :foreign_key => :post_id,
  :primary_key => :id
  )

  belongs_to(
  :friend_circle,
  :class_name => "FriendCircle",
  :foreign_key => :friend_circle_id,
  :primary_key => :id
  )

  validates :post_id, :friend_circle_id, :presence => true
end
