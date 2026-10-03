class AddAvatarToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :avatar_costume, :string
    add_column :users, :avatar_accessories, :string, array: true, default: [], null: false
  end
end
