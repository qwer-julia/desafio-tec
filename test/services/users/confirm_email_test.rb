require "test_helper"

class Users::ConfirmEmailTest < ActiveSupport::TestCase
  test "confirms the user for a valid token" do
    user = users(:unconfirmed)
    token = user.generate_token_for(:email_confirmation)

    result = Users::ConfirmEmail.new(token: token).call

    assert result.success
    assert result.object.confirmed?
  end

  test "fails for an invalid token" do
    result = Users::ConfirmEmail.new(token: "not-a-real-token").call

    assert_not result.success
  end

  test "a token becomes invalid once already used" do
    user = users(:unconfirmed)
    token = user.generate_token_for(:email_confirmation)
    Users::ConfirmEmail.new(token: token).call

    result = Users::ConfirmEmail.new(token: token).call

    assert_not result.success
  end
end
