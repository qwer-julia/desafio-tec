require "net/http"
require "json"

# Sends mail through the Brevo transactional email HTTP API instead of SMTP.
# Render blocks outbound SMTP ports, so ActionMailer must speak HTTPS to
# whichever provider we use; see config/environments/production.rb.
class BrevoDeliveryMethod
  class DeliveryError < StandardError; end

  ENDPOINT = URI("https://api.brevo.com/v3/smtp/email")

  attr_accessor :settings

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    request = Net::HTTP::Post.new(ENDPOINT)
    request["Content-Type"] = "application/json"
    request["api-key"] = settings.fetch(:api_key)
    request.body = payload(mail).to_json

    response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port, use_ssl: true) { |http| http.request(request) }

    unless response.is_a?(Net::HTTPSuccess)
      raise DeliveryError, "Brevo API returned #{response.code}: #{response.body}"
    end

    response
  end

  private

  def payload(mail)
    from = mail.header[:from].addrs.first

    {
      sender: { email: from.address, name: from.display_name }.compact,
      to: mail.to.map { |email| { email: email } },
      subject: mail.subject,
      htmlContent: html_body(mail),
      textContent: text_body(mail)
    }.compact
  end

  def html_body(mail)
    if mail.multipart?
      mail.html_part&.body&.decoded
    elsif mail.content_type&.include?("text/html")
      mail.body.decoded
    end
  end

  def text_body(mail)
    if mail.multipart?
      mail.text_part&.body&.decoded
    elsif mail.content_type.nil? || mail.content_type.include?("text/plain")
      mail.body.decoded
    end
  end
end
