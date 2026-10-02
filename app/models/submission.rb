class Submission < ApplicationRecord
  ZIP_CONTENT_TYPES = %w[ application/zip application/x-zip-compressed application/x-zip ].freeze
  MAX_FILE_SIZE = 50.megabytes

  belongs_to :user
  belongs_to :challenge
  has_one_attached :file

  validates :submitted_at, presence: true

  # Entregas que valem ponto: tudo conta, exceto desafios do parquinho (interns_only) entregues por quem não é estagiário.
  scope :scoring, -> {
    joins(:user, :challenge)
      .where(correct: true)
      .where("challenges.interns_only = FALSE OR users.intern = TRUE")
  }
  validate :file_is_a_zip

  private

  def file_is_a_zip
    return errors.add(:file, "não pode ficar em branco") unless file.attached?

    unless file.filename.extension.downcase == "zip" && file.content_type.in?(ZIP_CONTENT_TYPES)
      errors.add(:file, "precisa ser um arquivo .zip")
    end
    errors.add(:file, "precisa ter no máximo 50 MB") if file.byte_size > MAX_FILE_SIZE
  end
end
