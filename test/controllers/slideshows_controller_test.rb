require "test_helper"

class SlideshowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @slideshow = slideshows(:one)
  end

  test "should get index" do
    get slideshows_url
    assert_response :success
  end

  test "should get new" do
    get new_slideshow_url
    assert_response :success
  end

  test "should create slideshow" do
    assert_difference("Slideshow.count") do
      post slideshows_url, params: { slideshow: { announcements: @slideshow.announcements, fridayC: @slideshow.fridayC, fridayO: @slideshow.fridayO, mondayC: @slideshow.mondayC, mondayO: @slideshow.mondayO, nextFridayC: @slideshow.nextFridayC, nextFridayO: @slideshow.nextFridayO, nextMondayC: @slideshow.nextMondayC, nextMondayO: @slideshow.nextMondayO, nextThursdayC: @slideshow.nextThursdayC, nextThursdayO: @slideshow.nextThursdayO, nextTuesdayC: @slideshow.nextTuesdayC, nextTuesdayO: @slideshow.nextTuesdayO, nextWednesdayC: @slideshow.nextWednesdayC, nextWednesdayO: @slideshow.nextWednesdayO, quote: @slideshow.quote, thursdayC: @slideshow.thursdayC, thursdayO: @slideshow.thursdayO, tuesdayC: @slideshow.tuesdayC, tuesdayO: @slideshow.tuesdayO, wednesdayC: @slideshow.wednesdayC, wednesdayO: @slideshow.wednesdayO } }
    end

    assert_redirected_to slideshow_url(Slideshow.last)
  end

  test "should show slideshow" do
    get slideshow_url(@slideshow)
    assert_response :success
  end

  test "should get edit" do
    get edit_slideshow_url(@slideshow)
    assert_response :success
  end

  test "should update slideshow" do
    patch slideshow_url(@slideshow), params: { slideshow: { announcements: @slideshow.announcements, fridayC: @slideshow.fridayC, fridayO: @slideshow.fridayO, mondayC: @slideshow.mondayC, mondayO: @slideshow.mondayO, nextFridayC: @slideshow.nextFridayC, nextFridayO: @slideshow.nextFridayO, nextMondayC: @slideshow.nextMondayC, nextMondayO: @slideshow.nextMondayO, nextThursdayC: @slideshow.nextThursdayC, nextThursdayO: @slideshow.nextThursdayO, nextTuesdayC: @slideshow.nextTuesdayC, nextTuesdayO: @slideshow.nextTuesdayO, nextWednesdayC: @slideshow.nextWednesdayC, nextWednesdayO: @slideshow.nextWednesdayO, quote: @slideshow.quote, thursdayC: @slideshow.thursdayC, thursdayO: @slideshow.thursdayO, tuesdayC: @slideshow.tuesdayC, tuesdayO: @slideshow.tuesdayO, wednesdayC: @slideshow.wednesdayC, wednesdayO: @slideshow.wednesdayO } }
    assert_redirected_to slideshow_url(@slideshow)
  end

  test "should destroy slideshow" do
    assert_difference("Slideshow.count", -1) do
      delete slideshow_url(@slideshow)
    end

    assert_redirected_to slideshows_url
  end
end
