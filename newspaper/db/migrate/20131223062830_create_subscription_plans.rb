class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.integer :price, :null => false
      t.boolean :monthly_plan, :null => false
      t.integer :newspaper_id, :null => false

      t.timestamps
    end
  end
end
