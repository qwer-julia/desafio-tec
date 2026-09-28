require "test_helper"

class Invitations::CreateTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "creates an invitation and enqueues the invite email" do
    result = nil

    assert_enqueued_emails 1 do
      result = Invitations::Create.new(invited_by: users(:one), email_address: " New@Example.com ").call
    end

    assert result.success
    assert_equal "new@example.com", result.object.email_address
  end

  test "resends a pending invitation instead of failing" do
    assert_enqueued_emails 1 do
      assert_no_difference "Invitation.count" do
        assert Invitations::Create.new(invited_by: users(:one), email_address: "invited@example.com").call.success
      end
    end
  end

  test "fails for an email that already has an account" do
    result = Invitations::Create.new(invited_by: users(:one), email_address: "unconfirmed@example.com").call

    assert_not result.success
  end

  test "fails for an already accepted invitation" do
    assert_no_enqueued_emails do
      assert_not Invitations::Create.new(invited_by: users(:one), email_address: "two@example.com").call.success
    end
  end
end
