class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url, :null => false
      t.string :post_id, :null => false

      t.timestamps
    end
  end
end
