class Contact < ActiveRecord::Base
  attr_accessible :name, :email, :user_id

  belongs_to(
  :user,
  :class_name => 'User',
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :contact_shares,
  :class_name => "ContactShare",
  :foreign_key => :contact_id,
  :primary_key => :id
  )

  has_many(
  :contact_groups,
  :class_name => "ContactGroup",
  :foreign_key => :contact_id,
  :primary_key => :id
  )

  has_many(
  :comments,
  :class_name => "Comment",
  :foreign_key => :contact_id,
  :primary_key => :id
  )

  has_many :groups, :through => :contact_groups, :source => :group
  has_many :users, :through => :contact_shares, :source => :user

  validates :name, :email, :user_id, :presence => true

end
