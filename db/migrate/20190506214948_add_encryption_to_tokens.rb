class AddEncryptionToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_reddit_token, :string
    add_column :users, :encrypted_reddit_token_iv, :string
    add_column :users, :encrypted_refresh_token, :string
    add_column :users, :encrypted_refresh_token_iv, :string
  end
end
