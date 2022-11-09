require "test_helper"

class TurninginvsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @turninginv = turninginvs(:one)
  end

  test "should get index" do
    get turninginvs_url
    assert_response :success
  end

  test "should get new" do
    get new_turninginv_url
    assert_response :success
  end

  test "should create turninginv" do
    assert_difference("Turninginv.count") do
      post turninginvs_url, params: { turninginv: { balance: @turninginv.balance, buyer: @turninginv.buyer, description: @turninginv.description, employee: @turninginv.employee, last_email: @turninginv.last_email, last_received: @turninginv.last_received, location: @turninginv.location, minumum: @turninginv.minumum, part_number: @turninginv.part_number, remaining: @turninginv.remaining, to_take: @turninginv.to_take, vendor: @turninginv.vendor } }
    end

    assert_redirected_to turninginv_url(Turninginv.last)
  end

  test "should show turninginv" do
    get turninginv_url(@turninginv)
    assert_response :success
  end

  test "should get edit" do
    get edit_turninginv_url(@turninginv)
    assert_response :success
  end

  test "should update turninginv" do
    patch turninginv_url(@turninginv), params: { turninginv: { balance: @turninginv.balance, buyer: @turninginv.buyer, description: @turninginv.description, employee: @turninginv.employee, last_email: @turninginv.last_email, last_received: @turninginv.last_received, location: @turninginv.location, minumum: @turninginv.minumum, part_number: @turninginv.part_number, remaining: @turninginv.remaining, to_take: @turninginv.to_take, vendor: @turninginv.vendor } }
    assert_redirected_to turninginv_url(@turninginv)
  end

  test "should destroy turninginv" do
    assert_difference("Turninginv.count", -1) do
      delete turninginv_url(@turninginv)
    end

    assert_redirected_to turninginvs_url
  end
end
