require "test_helper"

class RunlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @runlist = runlists(:one)
  end

  test "should get index" do
    get runlists_url
    assert_response :success
  end

  test "should get new" do
    get new_runlist_url
    assert_response :success
  end

  test "should create runlist" do
    assert_difference("Runlist.count") do
      post runlists_url, params: { runlist: { Act_Scrap_Quantity: @runlist.Act_Scrap_Quantity, Certs_Required: @runlist.Certs_Required, Completed_Quantity: @runlist.Completed_Quantity, Customer: @runlist.Customer, Customer_PO: @runlist.Customer_PO, Customer_PO_LN: @runlist.Customer_PO_LN, Description: @runlist.Description, Extra_Quantity: @runlist.Extra_Quantity, FG_Transfer_Qty: @runlist.FG_Transfer_Qty, In_Production_Quantity: @runlist.In_Production_Quantity, Job: @runlist.Job, Job_Operation: @runlist.Job_Operation, Job_Sched_End: @runlist.Job_Sched_End, Job_Sched_Start: @runlist.Job_Sched_Start, Make_Quantity: @runlist.Make_Quantity, Mat_Description: @runlist.Mat_Description, Mat_Vendor: @runlist.Mat_Vendor, Material: @runlist.Material, Note_Text: @runlist.Note_Text, Open_Operations: @runlist.Open_Operations, Operation_Service: @runlist.Operation_Service, Order_Date: @runlist.Order_Date, Order_Quantity: @runlist.Order_Quantity, Part_Number: @runlist.Part_Number, Pick_Quantity: @runlist.Pick_Quantity, Released_Date: @runlist.Released_Date, Rev: @runlist.Rev, Sched_End: @runlist.Sched_End, Sched_Start: @runlist.Sched_Start, Sequence: @runlist.Sequence, Shipped_Quantity: @runlist.Shipped_Quantity, Vendor: @runlist.Vendor, WC_Vendor: @runlist.WC_Vendor, currentOp: @runlist.currentOp, dots: @runlist.dots, employee: @runlist.employee, matWaiting: @runlist.matWaiting } }
    end

    assert_redirected_to runlist_url(Runlist.last)
  end

  test "should show runlist" do
    get runlist_url(@runlist)
    assert_response :success
  end

  test "should get edit" do
    get edit_runlist_url(@runlist)
    assert_response :success
  end

  test "should update runlist" do
    patch runlist_url(@runlist), params: { runlist: { Act_Scrap_Quantity: @runlist.Act_Scrap_Quantity, Certs_Required: @runlist.Certs_Required, Completed_Quantity: @runlist.Completed_Quantity, Customer: @runlist.Customer, Customer_PO: @runlist.Customer_PO, Customer_PO_LN: @runlist.Customer_PO_LN, Description: @runlist.Description, Extra_Quantity: @runlist.Extra_Quantity, FG_Transfer_Qty: @runlist.FG_Transfer_Qty, In_Production_Quantity: @runlist.In_Production_Quantity, Job: @runlist.Job, Job_Operation: @runlist.Job_Operation, Job_Sched_End: @runlist.Job_Sched_End, Job_Sched_Start: @runlist.Job_Sched_Start, Make_Quantity: @runlist.Make_Quantity, Mat_Description: @runlist.Mat_Description, Mat_Vendor: @runlist.Mat_Vendor, Material: @runlist.Material, Note_Text: @runlist.Note_Text, Open_Operations: @runlist.Open_Operations, Operation_Service: @runlist.Operation_Service, Order_Date: @runlist.Order_Date, Order_Quantity: @runlist.Order_Quantity, Part_Number: @runlist.Part_Number, Pick_Quantity: @runlist.Pick_Quantity, Released_Date: @runlist.Released_Date, Rev: @runlist.Rev, Sched_End: @runlist.Sched_End, Sched_Start: @runlist.Sched_Start, Sequence: @runlist.Sequence, Shipped_Quantity: @runlist.Shipped_Quantity, Vendor: @runlist.Vendor, WC_Vendor: @runlist.WC_Vendor, currentOp: @runlist.currentOp, dots: @runlist.dots, employee: @runlist.employee, matWaiting: @runlist.matWaiting } }
    assert_redirected_to runlist_url(@runlist)
  end

  test "should destroy runlist" do
    assert_difference("Runlist.count", -1) do
      delete runlist_url(@runlist)
    end

    assert_redirected_to runlists_url
  end
end
