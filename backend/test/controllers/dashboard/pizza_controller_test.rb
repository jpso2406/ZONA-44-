require "test_helper"

class Dashboard::PizzaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_pizza_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_pizza_show_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_pizza_edit_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_pizza_new_url
    assert_response :success
  end
end
