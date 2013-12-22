class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.string :link_id, :null => false
      t.string :user_id, :null => false
      t.boolean :upvote, :null => false

      t.timestamps
    end
  end
end
