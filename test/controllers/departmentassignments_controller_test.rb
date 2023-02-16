require "test_helper"

class DepartmentassignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @departmentassignment = departmentassignments(:one)
  end

  test "should get index" do
    get departmentassignments_url
    assert_response :success
  end

  test "should get new" do
    get new_departmentassignment_url
    assert_response :success
  end

  test "should create departmentassignment" do
    assert_difference("Departmentassignment.count") do
      post departmentassignments_url, params: { departmentassignment: { departmentassignment: @departmentassignment.departmentassignment } }
    end

    assert_redirected_to departmentassignment_url(Departmentassignment.last)
  end

  test "should show departmentassignment" do
    get departmentassignment_url(@departmentassignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_departmentassignment_url(@departmentassignment)
    assert_response :success
  end

  test "should update departmentassignment" do
    patch departmentassignment_url(@departmentassignment), params: { departmentassignment: { departmentassignment: @departmentassignment.departmentassignment } }
    assert_redirected_to departmentassignment_url(@departmentassignment)
  end

  test "should destroy departmentassignment" do
    assert_difference("Departmentassignment.count", -1) do
      delete departmentassignment_url(@departmentassignment)
    end

    assert_redirected_to departmentassignments_url
  end
end
