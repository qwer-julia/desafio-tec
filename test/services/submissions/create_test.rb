require "test_helper"

class Submissions::CreateTest < ActiveSupport::TestCase
  test "stores the zip and counts the challenge as solved" do
    result = Submissions::Create.new(user: users(:one), challenge: challenges(:current_week), file: zip_upload).call

    assert result.success
    assert result.object.correct?
    assert_equal "solucao.zip", result.object.file.filename.to_s
    assert_equal 1, users(:one).points
  end

  test "rejects files that are not a zip" do
    result = Submissions::Create.new(user: users(:one), challenge: challenges(:current_week), file: txt_upload).call

    assert_not result.success
    assert_match "precisa ser um arquivo .zip", result.error_message
    assert_equal 0, users(:one).points
  end

  test "rejects a submission without a file" do
    result = Submissions::Create.new(user: users(:one), challenge: challenges(:current_week), file: nil).call

    assert_not result.success
    assert_equal 0, users(:one).points
  end

  test "blocks submissions once the user already solved it" do
    challenge = challenges(:current_week)
    Submissions::Create.new(user: users(:one), challenge: challenge, file: zip_upload).call

    result = Submissions::Create.new(user: users(:one), challenge: challenge, file: zip_upload).call

    assert_not result.success
    assert_equal "Você já resolveu esse desafio.", result.error_message
  end

  test "blocks submissions to a challenge that is not open" do
    result = Submissions::Create.new(user: users(:one), challenge: challenges(:last_week), file: zip_upload).call

    assert_not result.success
    assert_equal "Esse desafio não está aberto para respostas no momento.", result.error_message
  end

  test "blocks submissions to a challenge that has not opened yet" do
    result = Submissions::Create.new(user: users(:one), challenge: challenges(:next_week), file: zip_upload).call

    assert_not result.success
    assert_equal "Esse desafio não está aberto para respostas no momento.", result.error_message
  end

  private

  def zip_upload
    Rack::Test::UploadedFile.new(file_fixture("solucao.zip"), "application/zip")
  end

  def txt_upload
    Rack::Test::UploadedFile.new(file_fixture("solucao.txt"), "text/plain")
  end
end
