require "test_helper"

class Admin::PromocionesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_promociones_index_url
    assert_response :success
  end
end
