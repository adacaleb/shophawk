require "application_system_test_case"

class MillinginvsTest < ApplicationSystemTestCase
  setup do
    @millinginv = millinginvs(:one)
  end

  test "visiting the index" do
    visit millinginvs_url
    assert_selector "h1", text: "Millinginvs"
  end

  test "should create millinginv" do
    visit millinginvs_url
    click_on "New millinginv"

    fill_in "Balance", with: @millinginv.balance
    fill_in "Buyer", with: @millinginv.buyer
    fill_in "Description", with: @millinginv.description
    fill_in "Employee", with: @millinginv.employee
    fill_in "Hardwareid", with: @millinginv.hardwareid
    fill_in "Last email", with: @millinginv.last_email
    fill_in "Last received", with: @millinginv.last_received
    fill_in "Location", with: @millinginv.location
    fill_in "Mimumum", with: @millinginv.mimumum
    fill_in "Orderdate", with: @millinginv.orderdate
    fill_in "Part number", with: @millinginv.part_number
    fill_in "Status", with: @millinginv.status
    fill_in "To add", with: @millinginv.to_add
    fill_in "To take", with: @millinginv.to_take
    fill_in "Toolinfo", with: @millinginv.toolinfo
    fill_in "Vendor", with: @millinginv.vendor
    click_on "Create Millinginv"

    assert_text "Millinginv was successfully created"
    click_on "Back"
  end

  test "should update Millinginv" do
    visit millinginv_url(@millinginv)
    click_on "Edit this millinginv", match: :first

    fill_in "Balance", with: @millinginv.balance
    fill_in "Buyer", with: @millinginv.buyer
    fill_in "Description", with: @millinginv.description
    fill_in "Employee", with: @millinginv.employee
    fill_in "Hardwareid", with: @millinginv.hardwareid
    fill_in "Last email", with: @millinginv.last_email
    fill_in "Last received", with: @millinginv.last_received
    fill_in "Location", with: @millinginv.location
    fill_in "Mimumum", with: @millinginv.mimumum
    fill_in "Orderdate", with: @millinginv.orderdate
    fill_in "Part number", with: @millinginv.part_number
    fill_in "Status", with: @millinginv.status
    fill_in "To add", with: @millinginv.to_add
    fill_in "To take", with: @millinginv.to_take
    fill_in "Toolinfo", with: @millinginv.toolinfo
    fill_in "Vendor", with: @millinginv.vendor
    click_on "Update Millinginv"

    assert_text "Millinginv was successfully updated"
    click_on "Back"
  end

  test "should destroy Millinginv" do
    visit millinginv_url(@millinginv)
    click_on "Destroy this millinginv", match: :first

    assert_text "Millinginv was successfully destroyed"
  end
end
