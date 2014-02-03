class CreateGistfiles < ActiveRecord::Migration
  def change
    create_table :gistfiles do |t|
      t.string :name, :null => false
      t.string :body, :null => false
      t.integer :gist_id, :null => false

      t.timestamps
    end
  end
end
