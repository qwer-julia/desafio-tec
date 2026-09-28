require "test_helper"

class Admin::InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "non-admins cannot invite" do
    sign_in_as(users(:two))

    assert_no_difference "Invitation.count" do
      post admin_invitations_path, params: { invitation: { email_address: "x@example.com" } }
    end

    assert_redirected_to root_path
  end

  test "admins can send an invitation" do
    sign_in_as(users(:one))

    assert_enqueued_emails 1 do
      post admin_invitations_path, params: { invitation: { email_address: "x@example.com" } }
    end

    assert_redirected_to new_admin_invitation_path
  end

  test "admins see errors for invalid emails" do
    sign_in_as(users(:one))

    post admin_invitations_path, params: { invitation: { email_address: "not-an-email" } }

    assert_response :unprocessable_entity
  end
end
