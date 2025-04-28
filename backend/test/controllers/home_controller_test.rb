require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get bienvenidos" do
    get home_bienvenidos_url
    assert_response :success
  end

  test "should get menu" do
    get home_menu_url
    assert_response :success
  end
end
