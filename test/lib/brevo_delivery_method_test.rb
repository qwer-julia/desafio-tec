require "test_helper"

class BrevoDeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @mail = Mail.new do
      from "Desafio Tec <fonjulia89@gmail.com>"
      to "convidado@example.com"
      subject "Você foi convidado(a) para o Desafio Tec"
      text_part { body "texto simples" }
      html_part { content_type "text/html; charset=UTF-8"; body "<p>html</p>" }
    end
  end

  test "posts the mail as JSON to the Brevo API" do
    captured_request = nil
    fake_http = Object.new
    fake_http.define_singleton_method(:request) do |request|
      captured_request = request
      Net::HTTPCreated.new("1.1", "201", "Created")
    end

    Net::HTTP.stub(:start, ->(*, **, &blk) { blk.call(fake_http) }) do
      BrevoDeliveryMethod.new(api_key: "fake-key").deliver!(@mail)
    end

    assert_equal "/v3/smtp/email", captured_request.path
    assert_equal "fake-key", captured_request["api-key"]
    assert_equal "application/json", captured_request["Content-Type"]

    payload = JSON.parse(captured_request.body)
    assert_equal "fonjulia89@gmail.com", payload.dig("sender", "email")
    assert_equal "Desafio Tec", payload.dig("sender", "name")
    assert_equal [ "convidado@example.com" ], payload["to"].map { |r| r["email"] }
    assert_equal "<p>html</p>", payload["htmlContent"]
    assert_equal "texto simples", payload["textContent"]
  end

  test "raises DeliveryError when the API responds with an error" do
    fake_http = Object.new
    fake_http.define_singleton_method(:request) do |_request|
      response = Net::HTTPBadRequest.new("1.1", "400", "Bad Request")
      def response.body; '{"message":"invalid sender"}'; end
      response
    end

    Net::HTTP.stub(:start, ->(*, **, &blk) { blk.call(fake_http) }) do
      error = assert_raises(BrevoDeliveryMethod::DeliveryError) do
        BrevoDeliveryMethod.new(api_key: "fake-key").deliver!(@mail)
      end
      assert_match "invalid sender", error.message
    end
  end
end
