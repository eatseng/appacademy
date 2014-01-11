class Friendship < ActiveRecord::Base
  attr_accessible :in_friend_id, :out_friend_id

  belongs_to(
    :in_friend,
    :class_name => "User",
    :foreign_key => :in_friend_id,
    :primary_key => :id
  )

  belongs_to(
    :out_friend,
    :class_name => "User",
    :foreign_key => :out_friend_id,
    :primary_key => :id
  )

  validates :in_friend_id, :out_friend_id, :presence => true
  validates_uniqueness_of :in_friend_id, :scope => [:out_friend_id]
end
