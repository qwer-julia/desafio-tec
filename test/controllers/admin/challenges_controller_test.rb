require "test_helper"

class Admin::ChallengesControllerTest < ActionDispatch::IntegrationTest
  test "non-admins cannot access the new challenge form" do
    sign_in_as(users(:two))

    get new_admin_challenge_path

    assert_redirected_to root_path
  end

  test "admins can create a challenge" do
    sign_in_as(users(:one))

    assert_difference "Challenge.count", 1 do
      post admin_challenges_path, params: { challenge: {
        title: "Desafio novo",
        description: "desc",
        starts_at: 1.week.from_now,
        ends_at: 2.weeks.from_now
      } }
    end

    challenge = Challenge.find_by!(title: "Desafio novo")
    assert_redirected_to challenge_path(challenge)
  end

  test "admins can update a challenge" do
    sign_in_as(users(:one))
    challenge = challenges(:current_week)

    patch admin_challenge_path(challenge), params: { challenge: { title: "Título atualizado" } }

    assert_redirected_to challenge_path(challenge)
    challenge.reload
    assert_equal "Título atualizado", challenge.title
  end
end
