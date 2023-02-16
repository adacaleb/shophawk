require "application_system_test_case"

class DepartmentassignmentsTest < ApplicationSystemTestCase
  setup do
    @departmentassignment = departmentassignments(:one)
  end

  test "visiting the index" do
    visit departmentassignments_url
    assert_selector "h1", text: "Departmentassignments"
  end

  test "should create departmentassignment" do
    visit departmentassignments_url
    click_on "New departmentassignment"

    fill_in "Departmentassignment", with: @departmentassignment.departmentassignment
    click_on "Create Departmentassignment"

    assert_text "Departmentassignment was successfully created"
    click_on "Back"
  end

  test "should update Departmentassignment" do
    visit departmentassignment_url(@departmentassignment)
    click_on "Edit this departmentassignment", match: :first

    fill_in "Departmentassignment", with: @departmentassignment.departmentassignment
    click_on "Update Departmentassignment"

    assert_text "Departmentassignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Departmentassignment" do
    visit departmentassignment_url(@departmentassignment)
    click_on "Destroy this departmentassignment", match: :first

    assert_text "Departmentassignment was successfully destroyed"
  end
end
