class Invitation < ApplicationRecord
  belongs_to :invited_by, class_name: "User"

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: { message: "já convidado" }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :email_not_registered, on: :create

  generates_token_for :acceptance, expires_in: 7.days do
    accepted_at
  end

  def accepted?
    accepted_at.present?
  end

  private

  def email_not_registered
    errors.add(:email_address, "já tem conta") if User.exists?(email_address: email_address)
  end
end
