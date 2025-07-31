require "test_helper"

class Grupo::ProductoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grupo_producto_index_url
    assert_response :success
  end

  test "should get show" do
    get grupo_producto_show_url
    assert_response :success
  end
end
