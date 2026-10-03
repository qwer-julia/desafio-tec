class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :created_challenges, class_name: "Challenge", foreign_key: :created_by_id, dependent: :restrict_with_error

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, uniqueness: { message: "já utilizado" }
  validates :avatar_costume, inclusion: { in: Avatar::COSTUMES.keys }, allow_nil: true
  validate :avatar_accessories_known

  generates_token_for :email_confirmation, expires_in: 1.day do
    confirmed_at
  end

  scope :ranked_by_points, -> {
    left_joins(submissions: :challenge)
      .select("users.*, COUNT(CASE WHEN submissions.correct AND (challenges.interns_only = FALSE OR users.intern) THEN 1 END) AS points_count")
      .group(:id)
      .order(Arel.sql("points_count DESC, users.name ASC"))
  }

  def confirmed?
    confirmed_at.present?
  end

  def points
    submissions.scoring.count
  end

  def avatar_layers
    Avatar.layers(costume: avatar_costume, accessories: avatar_accessories)
  end

  private

  def avatar_accessories_known
    errors.add(:avatar_accessories, :invalid) unless (avatar_accessories - Avatar::ACCESSORIES.keys).empty?
  end
end
