class Post < ActiveRecord::Base
  attr_accessible :user_id, :body, :circle_ids, :link_attributes

  has_many(
  :links,
  :class_name => "Link",
  :foreign_key => :post_id,
  :primary_key => :id,
  :inverse_of => :post
  )

  has_many(
  :post_shares,
  :class_name => "PostShare",
  :foreign_key => :post_id,
  :primary_key => :id
  )

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  accepts_nested_attributes_for :links

  has_many :circles, :through => :post_shares, :source => :friend_circle

  validates :user_id, :body, :presence => true
end
