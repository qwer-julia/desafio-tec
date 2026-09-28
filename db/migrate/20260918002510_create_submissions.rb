class CreateSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.string :answer, null: false
      t.boolean :correct, null: false, default: false
      t.datetime :submitted_at, null: false

      t.timestamps
    end
    add_index :submissions, [ :user_id, :challenge_id, :correct ]
  end
end
