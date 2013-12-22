class Comment < ActiveRecord::Base
  attr_accessible :link_id, :comment_id, :user_id, :body

  has_many(
    :comments,
    :class_name => "Comment",
    :foreign_key => :comment_id,
    :primary_key => :id,
    dependent: :destroy
  )

  belongs_to(
    :parent_comment,
    :class_name => "Comment",
    :foreign_key => :comment_id,
    :primary_key => :id
  )

  belongs_to :link
  belongs_to :user

  validates :user, :link, :body, :presence => true
end
