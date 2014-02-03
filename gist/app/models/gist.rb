class Gist < ActiveRecord::Base
  attr_accessible :title, :user_id

  belongs_to :user
  has_one :favorite
  has_many :gistfiles

  validates :title, :user_id, :presence => true

  def to_json
    Jbuilder.encode do |json|
      json.(self, :id, :title, :user_id)
    end
  end

  def as_json(options)
    super(:include => :favorite)
  end

end
