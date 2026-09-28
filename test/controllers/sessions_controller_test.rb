require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "new" do
    get login_path
    assert_response :success
  end

  test "create with valid credentials" do
    post login_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post login_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to login_path
    assert_nil cookies[:session_id]
  end

  test "create blocks an unconfirmed user" do
    unconfirmed = users(:unconfirmed)
    post login_path, params: { email_address: unconfirmed.email_address, password: "password" }

    assert_redirected_to login_path
    assert_nil cookies[:session_id]

    follow_redirect!
    assert_select "div", /Confirme seu e-mail/
  end

  test "destroy" do
    sign_in_as(@user)

    delete logout_path

    assert_redirected_to login_path
    assert_empty cookies[:session_id]
  end
end
