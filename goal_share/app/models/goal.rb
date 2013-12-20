class Goal < ActiveRecord::Base
  attr_accessible :body, :completed, :private, :user_id
  BOOL = [true, false]

  belongs_to :user
  has_many :cheers

  before_validation :set_progress
  validates :body, :user_id, :presence => true
  validates :completed, :private, :inclusion => BOOL

  def set_progress
    self.completed ||= "0"
  end

  def completed!
    self.completed = "1"
    self.save
  end
end
