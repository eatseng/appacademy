class Gistfile < ActiveRecord::Base
  attr_accessible :body, :gist_id, :name

  belongs_to :gist

  validates :body, :gist_id, :name, :presence => true
end
