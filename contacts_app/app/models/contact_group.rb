class ContactGroup < ActiveRecord::Base
  attr_accessible :group_id, :contact_id

  belongs_to(
  :group,
  :class_name => "Group",
  :foreign_key => :group_id,
  :primary_key => :id
  )

  belongs_to(
  :contact,
  :class_name => "Contact",
  :foreign_key => :contact_id,
  :primary_key => :id
  )

end
