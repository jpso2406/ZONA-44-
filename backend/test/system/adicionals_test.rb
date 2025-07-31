require "application_system_test_case"

class AdicionalsTest < ApplicationSystemTestCase
  setup do
    @adicional = adicionals(:one)
  end

  test "visiting the index" do
    visit adicionals_url
    assert_selector "h1", text: "Adicionals"
  end

  test "should create adicional" do
    visit adicionals_url
    click_on "New adicional"

    fill_in "Ingredientes", with: @adicional.ingredientes
    click_on "Create Adicional"

    assert_text "Adicional was successfully created"
    click_on "Back"
  end

  test "should update Adicional" do
    visit adicional_url(@adicional)
    click_on "Edit this adicional", match: :first

    fill_in "Ingredientes", with: @adicional.ingredientes
    click_on "Update Adicional"

    assert_text "Adicional was successfully updated"
    click_on "Back"
  end

  test "should destroy Adicional" do
    visit adicional_url(@adicional)
    click_on "Destroy this adicional", match: :first

    assert_text "Adicional was successfully destroyed"
  end
end
