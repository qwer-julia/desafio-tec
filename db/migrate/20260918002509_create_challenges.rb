class CreateChallenges < ActiveRecord::Migration[8.1]
  def change
    create_table :challenges do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.string :answer_digest, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :challenges, :slug, unique: true
    add_index :challenges, :starts_at
  end
end
