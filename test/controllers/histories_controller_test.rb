require "test_helper"

class HistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @history = histories(:one)
  end

  test "should get index" do
    get histories_url
    assert_response :success
  end

  test "should get new" do
    get new_history_url
    assert_response :success
  end

  test "should create history" do
    assert_difference("History.count") do
      post histories_url, params: { history: { checkedin: @history.checkedin, checkedout: @history.checkedout, hlast_email: @history.hlast_email, hnew_balance: @history.hnew_balance, hpart_number: @history.hpart_number, turninginv_id: @history.turninginv_id } }
    end

    assert_redirected_to history_url(History.last)
  end

  test "should show history" do
    get history_url(@history)
    assert_response :success
  end

  test "should get edit" do
    get edit_history_url(@history)
    assert_response :success
  end

  test "should update history" do
    patch history_url(@history), params: { history: { checkedin: @history.checkedin, checkedout: @history.checkedout, hlast_email: @history.hlast_email, hnew_balance: @history.hnew_balance, hpart_number: @history.hpart_number, turninginv_id: @history.turninginv_id } }
    assert_redirected_to history_url(@history)
  end

  test "should destroy history" do
    assert_difference("History.count", -1) do
      delete history_url(@history)
    end

    assert_redirected_to histories_url
  end
end
