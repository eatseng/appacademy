class User < ActiveRecord::Base
  attr_accessible :name, :email

  has_many(
  :contacts,
  :class_name => 'Contact',
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :contact_shares,
  :class_name => "ContactShare",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :groups,
  :class_name => "Group",
  :foreign_key => :user_id,
  :primary_key => :id
  )

  has_many(
  :comments,
  :class_name => "Comment",
  :foreign_key => :user_id,
  :primary_key => :id
  )


  has_many :groups_contacts, :through => :groups, :source => :contacts
  has_many :shared_contacts, :through => :contact_shares, :source => :contact
  validates :name, :email, :presence => true

  def all_contacts
    contacts + shared_contacts
  end

  def favorite_contacts
    fav_shared = contact_shares.where(:favorite => 1).
                                map{ |share| share.contact }

    contacts.where(:favorite => 1) + fav_shared
  end

  def contacts_in_groups
    #groups_contacts

    # group_con = groups.includes(:contacts)
#
#     group_contacts = Hash.new{ |h,k| h[k] = [] }
#     group_con.each do |group|
#       group_contacts[group.group_name] << group.contacts
#     end
#     group_contacts
    sql = <<-SQL
    SELECT
      groups.group_name,
      contacts.*
    FROM
      groups
    JOIN
      contact_groups
      ON
      contact_groups.group_id = groups.id
    JOIN
      contacts
      ON
      contacts.id = contact_groups.contact_id
    WHERE
      groups.user_id = ?
    GROUP BY
      groups.group_name
    SQL

    Group.find_by_sql([sql, self.id])
  end

  def comments(contact_id)
    sql = <<-SQL
    SELECT
      comments.content,
      contacts.*
    FROM
      users
    JOIN
      comments
      ON
      comments.user_id = users.id
    JOIN
      contacts
      ON
      contacts.id = comments.contact_id
    WHERE
      comments.user_id = ? AND comments.contact_id = ?
    SQL

    Comment.find_by_sql([sql, self.id, contact_id])


  end
end
