class CreateLinkSubs < ActiveRecord::Migration
  def change
    create_table :link_subs do |t|
      t.integer :sub_id
      t.integer :link_id

      t.timestamps
    end
  end
end
