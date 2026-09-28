require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invitation = invitations(:pending)
    @token = @invitation.generate_token_for(:acceptance)
  end

  test "new with a valid invitation" do
    get signup_path(@token)
    assert_response :success
  end

  test "new with an invalid token redirects to login" do
    get signup_path("not-a-real-token")
    assert_redirected_to login_path
  end

  test "create registers a confirmed user with the invited email and signs them in" do
    assert_difference "User.count", 1 do
      post signup_path(@token), params: { user: {
        name: "New Person",
        email_address: "someone-else@example.com",
        password: "password",
        password_confirmation: "password"
      } }
    end

    assert_redirected_to root_path
    user = User.find_by!(email_address: "invited@example.com")
    assert user.confirmed?
    assert @invitation.reload.accepted?
    assert cookies[:session_id].present?
  end

  test "create without a valid invitation does not register anyone" do
    assert_no_difference "User.count" do
      post signup_path("not-a-real-token"), params: { user: { name: "X", password: "password", password_confirmation: "password" } }
    end

    assert_redirected_to login_path
  end

  test "an invitation cannot be used twice" do
    post signup_path(@token), params: { user: { name: "First", password: "password", password_confirmation: "password" } }
    sign_out

    get signup_path(@token)

    assert_redirected_to login_path
  end

  test "create with invalid params re-renders the form" do
    assert_no_difference "User.count" do
      post signup_path(@token), params: { user: { name: "", password: "password", password_confirmation: "different" } }
    end

    assert_response :unprocessable_entity
    assert_not @invitation.reload.accepted?
  end
end
