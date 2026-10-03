require "test_helper"

class ScoreboardControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "show lists users ranked by points, not by submission time" do
    get scoreboard_path
    assert_response :success

    body = css_select("table tbody tr").map(&:text)
    assert_match(/User Two/, body.first)
  end

  test "navbar links to the signed in user's profile with a face icon" do
    sign_in_as(users(:one))
    get root_path
    assert_select "nav a[href=?]", scoreboard_user_path(users(:one)) do
      assert_select "img[src=?]", "/avatar/neutro.png"
      assert_select "span", text: users(:one).name
    end
    assert_select "nav a", text: "Meu avatar", count: 0
    assert_select "nav a", text: "Meu calendário", count: 0
  end

  test "own profile shows full avatar, solved count and edit link" do
    sign_in_as(users(:one))
    get scoreboard_user_path(users(:one))
    assert_response :success
    assert_select "a[href=?]", edit_avatar_path, text: "Editar avatar"
    assert_select ".badge-mono", text: /desafios? resolvidos?/
  end

  test "someone else's profile has no edit avatar link" do
    sign_in_as(users(:one))
    get scoreboard_user_path(users(:two))
    assert_response :success
    assert_select "a[href=?]", edit_avatar_path, count: 0
  end

  test "show displays each user's avatar face" do
    users(:two).update!(avatar_costume: "mago")
    sign_in_as(users(:one))
    get scoreboard_path
    assert_select "tbody tr", minimum: 2
    assert_select "tbody img[src=?]", "/avatar/fantasia_mago.png", count: 1
    assert_select "tbody img[src=?]", "/avatar/neutro.png", minimum: 2
  end
end
