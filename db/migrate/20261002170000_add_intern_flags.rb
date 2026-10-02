class AddInternFlags < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :intern, :boolean, default: false, null: false
    add_column :challenges, :interns_only, :boolean, default: false, null: false
  end
end
