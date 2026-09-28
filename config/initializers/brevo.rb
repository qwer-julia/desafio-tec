require "brevo_delivery_method"

ActionMailer::Base.add_delivery_method :brevo, BrevoDeliveryMethod,
  api_key: Rails.application.credentials.dig(:brevo, :api_key)
