class AddLinkedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :linked, :boolean, default: false
  end
end
