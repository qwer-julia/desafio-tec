require "test_helper"

class ScoreboardControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "show lists users ranked by points, not by submission time" do
    get scoreboard_path
    assert_response :success

    body = css_select("table tbody tr").map(&:text)
    assert_match(/User Two/, body.first)
  end
end
