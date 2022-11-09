require "application_system_test_case"

class TurninginvsTest < ApplicationSystemTestCase
  setup do
    @turninginv = turninginvs(:one)
  end

  test "visiting the index" do
    visit turninginvs_url
    assert_selector "h1", text: "Turninginvs"
  end

  test "should create turninginv" do
    visit turninginvs_url
    click_on "New turninginv"

    fill_in "Balance", with: @turninginv.balance
    fill_in "Buyer", with: @turninginv.buyer
    fill_in "Description", with: @turninginv.description
    fill_in "Employee", with: @turninginv.employee
    fill_in "Last email", with: @turninginv.last_email
    fill_in "Last received", with: @turninginv.last_received
    fill_in "Location", with: @turninginv.location
    fill_in "Minumum", with: @turninginv.minumum
    fill_in "Part number", with: @turninginv.part_number
    fill_in "Remaining", with: @turninginv.remaining
    fill_in "To take", with: @turninginv.to_take
    fill_in "Vendor", with: @turninginv.vendor
    click_on "Create Turninginv"

    assert_text "Turninginv was successfully created"
    click_on "Back"
  end

  test "should update Turninginv" do
    visit turninginv_url(@turninginv)
    click_on "Edit this turninginv", match: :first

    fill_in "Balance", with: @turninginv.balance
    fill_in "Buyer", with: @turninginv.buyer
    fill_in "Description", with: @turninginv.description
    fill_in "Employee", with: @turninginv.employee
    fill_in "Last email", with: @turninginv.last_email
    fill_in "Last received", with: @turninginv.last_received
    fill_in "Location", with: @turninginv.location
    fill_in "Minumum", with: @turninginv.minumum
    fill_in "Part number", with: @turninginv.part_number
    fill_in "Remaining", with: @turninginv.remaining
    fill_in "To take", with: @turninginv.to_take
    fill_in "Vendor", with: @turninginv.vendor
    click_on "Update Turninginv"

    assert_text "Turninginv was successfully updated"
    click_on "Back"
  end

  test "should destroy Turninginv" do
    visit turninginv_url(@turninginv)
    click_on "Destroy this turninginv", match: :first

    assert_text "Turninginv was successfully destroyed"
  end
end
