class CreatePreferenceSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :preference_settings do |t|
      t.string :subreddits
      t.string :user_id
      t.timestamps
    end
  end
end
