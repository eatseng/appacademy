class Link < ActiveRecord::Base
  attr_accessible :url, :post_id

  belongs_to(
  :post,
  :class_name => "Post",
  :foreign_key => :post_id,
  :primary_key => :id
  )

  validates :url, :post, :presence => true
end
