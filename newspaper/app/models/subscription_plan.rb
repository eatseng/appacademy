class SubscriptionPlan < ActiveRecord::Base
  attr_accessible :price, :monthly_plan, :newspaper_id

  has_many :subscription, :dependent => :destroy
  belongs_to :newspaper

  validates :price, :newspaper, :presence => true
  validates :monthly_plan, :inclusion => [true, false]


end
