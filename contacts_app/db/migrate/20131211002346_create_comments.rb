class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, :null => false
      t.text :content, :null => false
      t.integer :contact_id, :null => false

      t.timestamps
    end
  end
end
