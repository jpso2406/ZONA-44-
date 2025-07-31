require "test_helper"

class MenuControllerTest < ActionDispatch::IntegrationTest
  test "should get hamburguesa" do
    get menu_hamburguesa_url
    assert_response :success
  end
end
