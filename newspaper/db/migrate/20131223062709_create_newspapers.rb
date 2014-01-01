class CreateNewspapers < ActiveRecord::Migration
  def change
    create_table :newspapers do |t|
      t.string :title, :null => false
      t.string :editor, :null => false

      t.timestamps
    end
  end
end
