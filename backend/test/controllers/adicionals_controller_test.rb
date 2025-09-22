require "test_helper"

class AdicionalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adicional = adicionals(:one)
  end

  test "should get index" do
    get adicionals_url
    assert_response :success
  end

  test "should get new" do
    get new_adicional_url
    assert_response :success
  end

  test "should create adicional" do
    assert_difference("Adicional.count") do
      post adicionals_url, params: { adicional: { ingredientes: @adicional.ingredientes } }
    end

    assert_redirected_to adicional_url(Adicional.last)
  end

  test "should show adicional" do
    get adicional_url(@adicional)
    assert_response :success
  end

  test "should get edit" do
    get edit_adicional_url(@adicional)
    assert_response :success
  end

  test "should update adicional" do
    patch adicional_url(@adicional), params: { adicional: { ingredientes: @adicional.ingredientes } }
    assert_redirected_to adicional_url(@adicional)
  end

  test "should destroy adicional" do
    assert_difference("Adicional.count", -1) do
      delete adicional_url(@adicional)
    end

    assert_redirected_to adicionals_url
  end
end
