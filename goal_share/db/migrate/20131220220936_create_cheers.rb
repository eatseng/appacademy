class CreateCheers < ActiveRecord::Migration
  def change
    create_table :cheers do |t|
      t.string :user_id
      t.string :goal_id

      t.timestamps
    end
  end
end
