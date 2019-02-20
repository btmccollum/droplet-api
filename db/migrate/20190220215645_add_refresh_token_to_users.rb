class AddRefreshTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :refresh_duration, :integer
  end
end
