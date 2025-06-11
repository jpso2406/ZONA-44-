require "application_system_test_case"

class SubgruposTest < ApplicationSystemTestCase
  setup do
    @subgrupo = subgrupos(:one)
  end

  test "visiting the index" do
    visit subgrupos_url
    assert_selector "h1", text: "Subgrupos"
  end

  test "should create subgrupo" do
    visit subgrupos_url
    click_on "New subgrupo"

    fill_in "Descripcion", with: @subgrupo.descripcion
    fill_in "Name", with: @subgrupo.name
    fill_in "Precio", with: @subgrupo.precio
    click_on "Create Subgrupo"

    assert_text "Subgrupo was successfully created"
    click_on "Back"
  end

  test "should update Subgrupo" do
    visit subgrupo_url(@subgrupo)
    click_on "Edit this subgrupo", match: :first

    fill_in "Descripcion", with: @subgrupo.descripcion
    fill_in "Name", with: @subgrupo.name
    fill_in "Precio", with: @subgrupo.precio
    click_on "Update Subgrupo"

    assert_text "Subgrupo was successfully updated"
    click_on "Back"
  end

  test "should destroy Subgrupo" do
    visit subgrupo_url(@subgrupo)
    click_on "Destroy this subgrupo", match: :first

    assert_text "Subgrupo was successfully destroyed"
  end
end
