class Link < ActiveRecord::Base
  attr_accessible :body, :user_id, :title, :url, :sub_ids

  validates :body, :user_id, :title, :url, :sub_ids, :presence => true

  belongs_to :user
  has_many :link_sub
  has_many :subs, :through => :link_sub, :source => :sub
  has_many :comments, :inverse_of => :link, dependent: :destroy
  has_many :user_votes, :dependent => :destroy

  def comments_by_parent_id
    hash = Hash.new {|hash, key| hash[key] = Array.new }
    all_comments = self.comments
    all_comments.each { |comment| hash[comment.comment_id] << comment }
    hash
  end

  def upvotes
    UserVote.where("link_id == ? AND upvote == ?", self.id, true).length
  end

  def downvotes
    UserVote.where("link_id == ? AND upvote == ?", self.id, false).length
  end
end
