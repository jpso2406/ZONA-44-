require "test_helper"

class SubgruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subgrupo = subgrupos(:one)
  end

  test "should get index" do
    get subgrupos_url
    assert_response :success
  end

  test "should get new" do
    get new_subgrupo_url
    assert_response :success
  end

  test "should create subgrupo" do
    assert_difference("Subgrupo.count") do
      post subgrupos_url, params: { subgrupo: { descripcion: @subgrupo.descripcion, name: @subgrupo.name, precio: @subgrupo.precio } }
    end

    assert_redirected_to subgrupo_url(Subgrupo.last)
  end

  test "should show subgrupo" do
    get subgrupo_url(@subgrupo)
    assert_response :success
  end

  test "should get edit" do
    get edit_subgrupo_url(@subgrupo)
    assert_response :success
  end

  test "should update subgrupo" do
    patch subgrupo_url(@subgrupo), params: { subgrupo: { descripcion: @subgrupo.descripcion, name: @subgrupo.name, precio: @subgrupo.precio } }
    assert_redirected_to subgrupo_url(@subgrupo)
  end

  test "should destroy subgrupo" do
    assert_difference("Subgrupo.count", -1) do
      delete subgrupo_url(@subgrupo)
    end

    assert_redirected_to subgrupos_url
  end
end
