require "test_helper"

class ChallengeTest < ActiveSupport::TestCase
  test "generates a unique slug from the title on create" do
    challenge = Challenge.create!(
      title: "Desafio da semana atual",
      description: "duplicate title slug",
      starts_at: 1.week.from_now,
      ends_at: 2.weeks.from_now,
      created_by: users(:one)
    )

    assert_equal "desafio-da-semana-atual-2", challenge.slug
  end

  test "invalid when ends_at is not after starts_at" do
    same_time = Time.current
    challenge = Challenge.new(
      title: "Teste",
      description: "desc",
      starts_at: same_time,
      ends_at: same_time,
      created_by: users(:one)
    )

    assert_not challenge.valid?
    assert_includes challenge.errors[:ends_at], "deve ser depois do início"
  end

  test ".current returns the open challenge" do
    assert_equal challenges(:current_week), Challenge.current
  end

  test "open?, past? and upcoming?" do
    assert challenges(:current_week).open?
    assert challenges(:last_week).past?
    assert challenges(:next_week).upcoming?
  end

  test "solved_by? and solvers" do
    assert challenges(:last_week).solved_by?(users(:two))
    assert_not challenges(:last_week).solved_by?(users(:one))
    assert_equal [ users(:two) ], challenges(:last_week).solvers
  end

  test "prize image must be a png" do
    challenge = challenges(:current_week)
    challenge.prize_image.attach(io: StringIO.new("not an image"), filename: "prize.jpg", content_type: "image/jpeg")
    assert_not challenge.valid?
    assert challenge.errors[:prize_image].any?
  end
end
