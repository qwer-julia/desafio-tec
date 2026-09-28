require "test_helper"

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "uploading a zip awards a point and shows the download link afterwards" do
    post challenge_submission_path(challenges(:current_week)), params: { file: fixture_file_upload("solucao.zip", "application/zip") }

    assert_redirected_to challenge_path(challenges(:current_week))
    follow_redirect!
    assert_select "div", /Entrega recebida/
    assert_select "a", "solucao.zip"

    assert_equal 1, users(:one).points
  end

  test "uploading something that is not a zip does not award a point" do
    post challenge_submission_path(challenges(:current_week)), params: { file: fixture_file_upload("solucao.txt", "text/plain") }

    assert_redirected_to challenge_path(challenges(:current_week))
    follow_redirect!
    assert_select "div", /precisa ser um arquivo .zip/

    assert_equal 0, users(:one).points
  end

  test "cannot submit to a closed challenge" do
    post challenge_submission_path(challenges(:last_week)), params: { file: fixture_file_upload("solucao.zip", "application/zip") }

    assert_redirected_to challenge_path(challenges(:last_week))
    follow_redirect!
    assert_select "div", /não está aberto/
  end
end
