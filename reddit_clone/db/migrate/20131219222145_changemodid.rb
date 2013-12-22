class Changemodid < ActiveRecord::Migration
  def change
    rename_column :subs, :mod_id, :user_id
  end

  def down
  end
end
