require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "confirms the user and signs them in" do
    user = users(:unconfirmed)
    token = user.generate_token_for(:email_confirmation)

    get confirm_email_path(token)

    assert_redirected_to root_path
    assert cookies[:session_id]
    assert user.reload.confirmed?
  end

  test "invalid token redirects to login with an alert" do
    get confirm_email_path("not-a-real-token")

    assert_redirected_to login_path
    assert_nil cookies[:session_id]
  end
end
