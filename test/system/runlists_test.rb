require "application_system_test_case"

class RunlistsTest < ApplicationSystemTestCase
  setup do
    @runlist = runlists(:one)
  end

  test "visiting the index" do
    visit runlists_url
    assert_selector "h1", text: "Runlists"
  end

  test "should create runlist" do
    visit runlists_url
    click_on "New runlist"

    fill_in "Act scrap quantity", with: @runlist.Act_Scrap_Quantity
    check "Certs required" if @runlist.Certs_Required
    fill_in "Completed quantity", with: @runlist.Completed_Quantity
    fill_in "Customer", with: @runlist.Customer
    fill_in "Customer po", with: @runlist.Customer_PO
    fill_in "Customer po ln", with: @runlist.Customer_PO_LN
    fill_in "Description", with: @runlist.Description
    fill_in "Extra quantity", with: @runlist.Extra_Quantity
    fill_in "Fg transfer qty", with: @runlist.FG_Transfer_Qty
    fill_in "In production quantity", with: @runlist.In_Production_Quantity
    fill_in "Job", with: @runlist.Job
    fill_in "Job operation", with: @runlist.Job_Operation
    fill_in "Job sched end", with: @runlist.Job_Sched_End
    fill_in "Job sched start", with: @runlist.Job_Sched_Start
    fill_in "Make quantity", with: @runlist.Make_Quantity
    fill_in "Mat description", with: @runlist.Mat_Description
    fill_in "Mat vendor", with: @runlist.Mat_Vendor
    fill_in "Material", with: @runlist.Material
    fill_in "Note text", with: @runlist.Note_Text
    fill_in "Open operations", with: @runlist.Open_Operations
    fill_in "Operation service", with: @runlist.Operation_Service
    fill_in "Order date", with: @runlist.Order_Date
    fill_in "Order quantity", with: @runlist.Order_Quantity
    fill_in "Part number", with: @runlist.Part_Number
    fill_in "Pick quantity", with: @runlist.Pick_Quantity
    fill_in "Released date", with: @runlist.Released_Date
    fill_in "Rev", with: @runlist.Rev
    fill_in "Sched end", with: @runlist.Sched_End
    fill_in "Sched start", with: @runlist.Sched_Start
    fill_in "Sequence", with: @runlist.Sequence
    fill_in "Shipped quantity", with: @runlist.Shipped_Quantity
    fill_in "Vendor", with: @runlist.Vendor
    fill_in "Wc vendor", with: @runlist.WC_Vendor
    fill_in "Currentop", with: @runlist.currentOp
    fill_in "Dots", with: @runlist.dots
    fill_in "Employee", with: @runlist.employee
    check "Matwaiting" if @runlist.matWaiting
    click_on "Create Runlist"

    assert_text "Runlist was successfully created"
    click_on "Back"
  end

  test "should update Runlist" do
    visit runlist_url(@runlist)
    click_on "Edit this runlist", match: :first

    fill_in "Act scrap quantity", with: @runlist.Act_Scrap_Quantity
    check "Certs required" if @runlist.Certs_Required
    fill_in "Completed quantity", with: @runlist.Completed_Quantity
    fill_in "Customer", with: @runlist.Customer
    fill_in "Customer po", with: @runlist.Customer_PO
    fill_in "Customer po ln", with: @runlist.Customer_PO_LN
    fill_in "Description", with: @runlist.Description
    fill_in "Extra quantity", with: @runlist.Extra_Quantity
    fill_in "Fg transfer qty", with: @runlist.FG_Transfer_Qty
    fill_in "In production quantity", with: @runlist.In_Production_Quantity
    fill_in "Job", with: @runlist.Job
    fill_in "Job operation", with: @runlist.Job_Operation
    fill_in "Job sched end", with: @runlist.Job_Sched_End
    fill_in "Job sched start", with: @runlist.Job_Sched_Start
    fill_in "Make quantity", with: @runlist.Make_Quantity
    fill_in "Mat description", with: @runlist.Mat_Description
    fill_in "Mat vendor", with: @runlist.Mat_Vendor
    fill_in "Material", with: @runlist.Material
    fill_in "Note text", with: @runlist.Note_Text
    fill_in "Open operations", with: @runlist.Open_Operations
    fill_in "Operation service", with: @runlist.Operation_Service
    fill_in "Order date", with: @runlist.Order_Date
    fill_in "Order quantity", with: @runlist.Order_Quantity
    fill_in "Part number", with: @runlist.Part_Number
    fill_in "Pick quantity", with: @runlist.Pick_Quantity
    fill_in "Released date", with: @runlist.Released_Date
    fill_in "Rev", with: @runlist.Rev
    fill_in "Sched end", with: @runlist.Sched_End
    fill_in "Sched start", with: @runlist.Sched_Start
    fill_in "Sequence", with: @runlist.Sequence
    fill_in "Shipped quantity", with: @runlist.Shipped_Quantity
    fill_in "Vendor", with: @runlist.Vendor
    fill_in "Wc vendor", with: @runlist.WC_Vendor
    fill_in "Currentop", with: @runlist.currentOp
    fill_in "Dots", with: @runlist.dots
    fill_in "Employee", with: @runlist.employee
    check "Matwaiting" if @runlist.matWaiting
    click_on "Update Runlist"

    assert_text "Runlist was successfully updated"
    click_on "Back"
  end

  test "should destroy Runlist" do
    visit runlist_url(@runlist)
    click_on "Destroy this runlist", match: :first

    assert_text "Runlist was successfully destroyed"
  end
end
