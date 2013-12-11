class AddContactGroup < ActiveRecord::Migration
  def change
    remove_column :groups, :contact_id

    create_table :contact_groups do |t|
      t.integer :group_id, :null => false
      t.integer :contact_id, :null => false

      t.timestamps
    end
  end

  def down
  end
end
