class AddPrizeNameToChallenges < ActiveRecord::Migration[8.1]
  def change
    add_column :challenges, :prize_name, :string
  end
end
