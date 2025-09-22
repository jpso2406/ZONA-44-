require "test_helper"

class GrupoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grupo_index_url
    assert_response :success
  end

  test "should get show" do
    get grupo_show_url
    assert_response :success
  end

  test "should get new" do
    get grupo_new_url
    assert_response :success
  end
end
