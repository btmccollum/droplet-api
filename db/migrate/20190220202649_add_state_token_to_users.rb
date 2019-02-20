class AddStateTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :state_token, :string
  end
end
