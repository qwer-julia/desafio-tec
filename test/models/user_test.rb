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
end
