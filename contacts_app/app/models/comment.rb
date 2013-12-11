class Comment < ActiveRecord::Base
  attr_accessible :user_id, :content, :contact_id

  belongs_to(
  :contact,
  :class_name => "Contact",
  :foreign_key => :contact_id,
  :primary_key => :id
  )

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )
end
