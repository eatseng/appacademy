class AddGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id, :null => false
      t.integer :contact_id, :null => false

      t.timestamps
    end
  end

  def down
  end
end
