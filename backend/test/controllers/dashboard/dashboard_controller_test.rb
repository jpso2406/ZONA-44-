require "test_helper"

class Dashboard::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_dashboard_index_url
    assert_response :success
  end
end
