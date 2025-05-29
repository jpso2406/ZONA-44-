require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get bienvenida" do
    get home_bienvenida_url
    assert_response :success
  end
end
