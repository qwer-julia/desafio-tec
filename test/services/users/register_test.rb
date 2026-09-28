require "test_helper"

class Users::RegisterTest < ActiveSupport::TestCase
  test "creates a confirmed user with the invitation email and accepts the invitation" do
    invitation = invitations(:pending)

    result = Users::Register.new(
      invitation: invitation,
      user_params: { name: "New", password: "password", password_confirmation: "password" }
    ).call

    assert result.success
    assert result.object.confirmed?
    assert_equal "invited@example.com", result.object.email_address
    assert invitation.reload.accepted?
  end

  test "fails when passwords do not match and keeps the invitation pending" do
    invitation = invitations(:pending)

    result = Users::Register.new(
      invitation: invitation,
      user_params: { name: "New", password: "password", password_confirmation: "different" }
    ).call

    assert_not result.success
    assert_not invitation.reload.accepted?
  end
end
