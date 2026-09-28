require "test_helper"

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "index requires authentication" do
    sign_out
    get challenges_path
    assert_redirected_to login_path
  end

  test "index shows the current challenge and the archive" do
    get challenges_path
    assert_response :success
  end

  test "index highlights the weekly prize over a spinning star" do
    challenges(:current_week).update!(prize_name: "Brigadeiro", prize_image: fixture_file_upload("prize.png", "image/png"))

    get challenges_path
    assert_select ".prize-spotlight img[alt=?]", "Brigadeiro"
    assert_select ".prize-spotlight__star polygon"
  end

  test "index skips the prize highlight when there is no prize image" do
    get challenges_path
    assert_select ".prize-spotlight", count: 0
  end

  test "show renders the challenge with its solvers, alphabetically, never by submission time" do
    get challenge_path(challenges(:last_week))
    assert_response :success

    body_names = css_select("li").map(&:text)
    assert_includes body_names.join, users(:two).name
  end

  test "show lets a signed in user answer an open challenge" do
    get challenge_path(challenges(:current_week))
    assert_response :success
    assert_select "form input[type=file][name=file]"
  end
end
