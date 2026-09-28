require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "mine shows only past and current challenges" do
    get calendar_path
    assert_response :success
    assert_no_match challenges(:next_week).title, response.body
  end

  test "team shows who delivered inside the square of the day they delivered" do
    get team_calendar_path
    assert_response :success

    delivered_on = submissions(:two_solved_last_week).submitted_at.to_date
    assert_select ".calendar-day", minimum: 28
    assert_select ".calendar-day" do |days|
      square = days.find { |day| day.at_css(".calendar-day__number").text.to_i == delivered_on.day && day.text.include?(users(:two).name) }
      assert square, "expected #{users(:two).name} on day #{delivered_on.day}"
    end
  end

  test "team does not list wrong attempts" do
    get team_calendar_path
    assert_select ".calendar-day__name", count: 1
  end
end
