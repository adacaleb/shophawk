require "test_helper"

class MillinginvsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @millinginv = millinginvs(:one)
  end

  test "should get index" do
    get millinginvs_url
    assert_response :success
  end

  test "should get new" do
    get new_millinginv_url
    assert_response :success
  end

  test "should create millinginv" do
    assert_difference("Millinginv.count") do
      post millinginvs_url, params: { millinginv: { balance: @millinginv.balance, buyer: @millinginv.buyer, description: @millinginv.description, employee: @millinginv.employee, hardwareid: @millinginv.hardwareid, last_email: @millinginv.last_email, last_received: @millinginv.last_received, location: @millinginv.location, mimumum: @millinginv.mimumum, orderdate: @millinginv.orderdate, part_number: @millinginv.part_number, status: @millinginv.status, to_add: @millinginv.to_add, to_take: @millinginv.to_take, toolinfo: @millinginv.toolinfo, vendor: @millinginv.vendor } }
    end

    assert_redirected_to millinginv_url(Millinginv.last)
  end

  test "should show millinginv" do
    get millinginv_url(@millinginv)
    assert_response :success
  end

  test "should get edit" do
    get edit_millinginv_url(@millinginv)
    assert_response :success
  end

  test "should update millinginv" do
    patch millinginv_url(@millinginv), params: { millinginv: { balance: @millinginv.balance, buyer: @millinginv.buyer, description: @millinginv.description, employee: @millinginv.employee, hardwareid: @millinginv.hardwareid, last_email: @millinginv.last_email, last_received: @millinginv.last_received, location: @millinginv.location, mimumum: @millinginv.mimumum, orderdate: @millinginv.orderdate, part_number: @millinginv.part_number, status: @millinginv.status, to_add: @millinginv.to_add, to_take: @millinginv.to_take, toolinfo: @millinginv.toolinfo, vendor: @millinginv.vendor } }
    assert_redirected_to millinginv_url(@millinginv)
  end

  test "should destroy millinginv" do
    assert_difference("Millinginv.count", -1) do
      delete millinginv_url(@millinginv)
    end

    assert_redirected_to millinginvs_url
  end
end
