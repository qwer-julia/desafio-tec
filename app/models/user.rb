class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :created_challenges, class_name: "Challenge", foreign_key: :created_by_id, dependent: :restrict_with_error

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, uniqueness: { message: "já utilizado" }

  generates_token_for :email_confirmation, expires_in: 1.day do
    confirmed_at
  end

  scope :ranked_by_points, -> {
    left_joins(:submissions)
      .select("users.*, COUNT(CASE WHEN submissions.correct THEN 1 END) AS points_count")
      .group(:id)
      .order(Arel.sql("points_count DESC, users.name ASC"))
  }

  def confirmed?
    confirmed_at.present?
  end

  def points
    submissions.where(correct: true).count
  end
end
