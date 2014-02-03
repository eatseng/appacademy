class Favorite < ActiveRecord::Base
  attr_accessible :gist_id, :user_id

  belongs_to :user

  validates :gist_id, :user_id, :presence => true
  validates_uniqueness_of :user_id, :scope => [:gist_id]
end
