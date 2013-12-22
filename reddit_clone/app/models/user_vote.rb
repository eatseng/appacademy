class UserVote < ActiveRecord::Base
  attr_accessible :link_id, :upvote, :user_id

  belongs_to :link

  validates :link_id, :user_id, :presence => true
  validates :upvote, :inclusion => [true, false]
  validates_uniqueness_of :user_id, :scope => [:link_id]
end
