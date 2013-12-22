class Sub < ActiveRecord::Base
  attr_accessible :name, :user_id

  validates :name, :user_id, :presence => true

  belongs_to :user
  has_many :link_subs
  has_many :links, :through => :link_subs, :source => :link
  has_many :votes, :through => :links, :source => :user_votes

  def up_votes
    self.votes.where('upvote == ?', true).length
  end

  def down_votes
    self.votes.where('upvote == ?', false).length
  end

  def self.sub_ranking
    Sub.select("subs.*, COUNT(user_votes.upvote) as votes")
        .joins(:votes)
        .group("subs.id")
        .order("votes DESC")
  end

  def link_ranking
    Link.select("links.*, COUNT(user_votes.upvote) as votes")
        .joins("LEFT OUTER JOIN user_votes ON links.id = user_votes.link_id")
        .joins(:subs)
        .where('subs.id == ?', self.id)
        .group("links.created_at")
        .order("votes DESC")
  end
end
