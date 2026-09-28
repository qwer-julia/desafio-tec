class ReplaceTextAnswersWithZipUploads < ActiveRecord::Migration[8.1]
  def change
    remove_column :challenges, :answer_digest, :string
    remove_column :submissions, :answer, :string
  end
end
