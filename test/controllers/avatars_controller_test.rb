require "test_helper"

class AvatarsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "show previews the base mascot" do
    get edit_avatar_path
    assert_response :success
    assert_select "img[data-layer=neutro]"
  end

  test "update saves one costume and accessories" do
    patch avatar_path, params: { user: { avatar_costume: "mago", avatar_accessories: [ "", "oculos_sol", "bigode" ] } }
    assert_redirected_to scoreboard_user_path(users(:one))
    user = users(:one).reload
    assert_equal "mago", user.avatar_costume
    assert_equal %w[oculos_sol bigode], user.avatar_accessories
  end

  test "accessories are layered above the costume" do
    users(:one).update!(avatar_costume: "nerd", avatar_accessories: %w[cigarro oculos_grau])
    assert_equal %w[neutro fantasia_nerd oculos_grau cigarro], users(:one).avatar_layers
  end

  test "blank costume clears it" do
    users(:one).update!(avatar_costume: "mago")
    patch avatar_path, params: { user: { avatar_costume: "" } }
    assert_nil users(:one).reload.avatar_costume
  end

  test "rejects unknown layers" do
    patch avatar_path, params: { user: { avatar_costume: "../x", avatar_accessories: [ "x" ] } }
    assert_response :unprocessable_entity
    assert_nil users(:one).reload.avatar_costume
  end

  test "requires login" do
    delete logout_path
    get edit_avatar_path
    assert_redirected_to login_path
  end
end
