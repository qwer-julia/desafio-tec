require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "confirmed? is false without confirmed_at" do
    assert_not users(:unconfirmed).confirmed?
  end

  test "confirmed? is true with confirmed_at" do
    assert users(:one).confirmed?
  end

  test "points counts only correct submissions" do
    assert_equal 1, users(:two).points
    assert_equal 0, users(:one).points
  end

  test "ranked_by_points orders by points desc then name" do
    ranked = User.ranked_by_points.to_a
    assert_equal users(:two), ranked.first
    assert_equal 1, ranked.first.points_count
  end

  test "intern earns points on interns-only challenges" do
    challenge = challenges(:interns_week)
    submission = Submission.new(user: users(:intern), challenge: challenge, correct: true, submitted_at: Time.current)
    submission.file.attach(io: StringIO.new("zip"), filename: "a.zip", content_type: "application/zip")
    submission.save!

    assert_equal 1, users(:intern).points
    assert_equal 1, User.ranked_by_points.find { |u| u == users(:intern) }.points_count
  end

  test "non-intern earns no points on interns-only challenges but keeps the submission" do
    challenge = challenges(:interns_week)
    submission = Submission.new(user: users(:two), challenge: challenge, correct: true, submitted_at: Time.current)
    submission.file.attach(io: StringIO.new("zip"), filename: "a.zip", content_type: "application/zip")
    submission.save!

    assert challenge.solved_by?(users(:two))
    assert_equal 1, users(:two).points
    assert_equal 1, User.ranked_by_points.find { |u| u == users(:two) }.points_count
  end

  test "scores_for? is true for everyone on regular challenges and only interns on interns-only ones" do
    assert challenges(:current_week).scores_for?(users(:two))
    assert_not challenges(:interns_week).scores_for?(users(:two))
    assert challenges(:interns_week).scores_for?(users(:intern))
  end
end
