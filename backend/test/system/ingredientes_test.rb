require "application_system_test_case"

class IngredientesTest < ApplicationSystemTestCase
  setup do
    @ingrediente = ingredientes(:one)
  end

  test "visiting the index" do
    visit ingredientes_url
    assert_selector "h1", text: "Ingredientes"
  end

  test "should create ingrediente" do
    visit ingredientes_url
    click_on "New ingrediente"

    fill_in "Nombre", with: @ingrediente.nombre
    click_on "Create Ingrediente"

    assert_text "Ingrediente was successfully created"
    click_on "Back"
  end

  test "should update Ingrediente" do
    visit ingrediente_url(@ingrediente)
    click_on "Edit this ingrediente", match: :first

    fill_in "Nombre", with: @ingrediente.nombre
    click_on "Update Ingrediente"

    assert_text "Ingrediente was successfully updated"
    click_on "Back"
  end

  test "should destroy Ingrediente" do
    visit ingrediente_url(@ingrediente)
    click_on "Destroy this ingrediente", match: :first

    assert_text "Ingrediente was successfully destroyed"
  end
end
