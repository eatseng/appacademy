class Addfavorite < ActiveRecord::Migration
  def change
    add_column :contacts, :favorite, :boolean
    add_column :contact_shares, :favorite, :boolean
  end

  def down
  end
end
