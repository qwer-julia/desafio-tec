require "test_helper"

class Challenges::CreateTest < ActiveSupport::TestCase
  test "creates a challenge" do
    result = Challenges::Create.new(
      created_by: users(:one),
      challenge_params: {
        title: "Novo desafio",
        description: "desc",
        starts_at: 1.week.from_now,
        ends_at: 2.weeks.from_now
      }
    ).call

    assert result.success
    assert_equal users(:one), result.object.created_by
  end

  test "fails validation without required fields" do
    result = Challenges::Create.new(
      created_by: users(:one),
      challenge_params: { title: "", description: "", starts_at: nil, ends_at: nil }
    ).call

    assert_not result.success
    assert result.error_message.present?
  end
end
