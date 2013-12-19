class FriendCircle < ActiveRecord::Base
  attr_accessible :name, :user_id, :member_ids

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :memberships,
  :class_name => "FriendCircleMembership",
  :foreign_key => :friend_circle_id,
  :primary_key => :id
  )

  has_many(
  :post_shares,
  :class_name => "PostShare",
  :foreign_key => :friend_circle_id,
  :primary_key => :id
  )

  has_many :members, :through => :memberships, :source => :user_member
  has_many :posts, :through => :post_shares, :source => :post
  validates :name, :presence => true
end
