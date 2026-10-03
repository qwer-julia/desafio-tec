class Challenge < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_many :submissions, dependent: :destroy
  has_one_attached :prize_image

  before_validation :generate_slug, on: :create

  validates :title, presence: true
  validates :description, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :starts_at, :ends_at, presence: true
  validate :ends_at_after_starts_at
  validate :prize_image_is_png

  scope :ordered, -> { order(starts_at: :asc) }
  scope :past, -> { where("ends_at <= ?", Time.current).ordered }
  scope :upcoming, -> { where("starts_at > ?", Time.current).ordered }

  scope :open_now, -> { where("starts_at <= :now AND ends_at > :now", now: Time.current).order(starts_at: :desc, id: :desc) }

  def self.current
    where("starts_at <= :now AND ends_at > :now", now: Time.current).order(starts_at: :desc).first
  end

  def to_param
    slug
  end

  def open?
    starts_at <= Time.current && Time.current < ends_at
  end

  def past?
    Time.current >= ends_at
  end

  def upcoming?
    Time.current < starts_at
  end

  def scores_for?(user)
    !interns_only? || user.intern?
  end

  def solved_by?(user)
    submissions.exists?(user: user, correct: true)
  end

  def submission_for(user)
    submissions.where(user: user, correct: true).order(submitted_at: :desc).first
  end

  def solvers
    User.joins(:submissions).where(submissions: { challenge_id: id, correct: true }).distinct.order(:name)
  end

  private

  def generate_slug
    return if title.blank?

    base = title.parameterize
    candidate = base
    suffix = 2
    while Challenge.exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    self.slug = candidate
  end

  def prize_image_is_png
    return unless prize_image.attached?

    errors.add(:prize_image, "precisa ser PNG (de preferência sem fundo)") unless prize_image.content_type == "image/png"
  end

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "deve ser depois do início") if ends_at <= starts_at
  end
end
