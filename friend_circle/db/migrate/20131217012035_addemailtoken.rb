class Addemailtoken < ActiveRecord::Migration
  def change
    add_column :users, :email_token, :string
  end

  def down
  end
end
