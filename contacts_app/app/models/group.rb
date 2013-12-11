class Group < ActiveRecord::Base
  attr_accessible :user_id, :group_name

  belongs_to(
  :user,
  :class_name => "User",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :contact_groups,
  :class_name => "ContactGroup",
  :foreign_key => :group_id,
  :primary_key => :id
  )

  has_many :contacts, :through => :contact_groups, :source => :contact

end
