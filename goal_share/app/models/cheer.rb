class Cheer < ActiveRecord::Base
  attr_accessible :goal_id, :user_id

  belongs_to :user
  belongs_to :goal

  validates :goal_id, :user_id, :presence => true
end
