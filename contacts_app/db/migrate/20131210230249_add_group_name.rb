class AddGroupName < ActiveRecord::Migration
  def change
    add_column :groups, :group_name, :string
  end

  def down
  end
end
