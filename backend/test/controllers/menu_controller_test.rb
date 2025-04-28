require "test_helper"

class MenuControllerTest < ActionDispatch::IntegrationTest
  test "should get hamburguesa" do
    get menu_hamburguesa_url
    assert_response :success
  end

  test "should get salchipapa" do
    get menu_salchipapa_url
    assert_response :success
  end

  test "should get perrocaliente" do
    get menu_perrocaliente_url
    assert_response :success
  end
end
