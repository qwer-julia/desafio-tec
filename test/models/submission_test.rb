require "test_helper"

class SubmissionTest < ActiveSupport::TestCase
  test "requires a file" do
    submission = Submission.new(user: users(:one), challenge: challenges(:current_week), submitted_at: Time.current)
    assert_not submission.valid?
    assert_includes submission.errors[:file], "não pode ficar em branco"
  end
end
