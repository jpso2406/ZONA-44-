require "application_system_test_case"

class GruposTest < ApplicationSystemTestCase
  setup do
    @grupo = grupos(:one)
  end

  test "visiting the index" do
    visit grupos_url
    assert_selector "h1", text: "Grupos"
  end

  test "should create grupo" do
    visit grupos_url
    click_on "New grupo"

    fill_in "Name", with: @grupo.name
    click_on "Create Grupo"

    assert_text "Grupo was successfully created"
    click_on "Back"
  end

  test "should update Grupo" do
    visit grupo_url(@grupo)
    click_on "Edit this grupo", match: :first

    fill_in "Name", with: @grupo.name
    click_on "Update Grupo"

    assert_text "Grupo was successfully updated"
    click_on "Back"
  end

  test "should destroy Grupo" do
    visit grupo_url(@grupo)
    click_on "Destroy this grupo", match: :first

    assert_text "Grupo was successfully destroyed"
  end
end
