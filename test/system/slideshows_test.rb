require "application_system_test_case"

class SlideshowsTest < ApplicationSystemTestCase
  setup do
    @slideshow = slideshows(:one)
  end

  test "visiting the index" do
    visit slideshows_url
    assert_selector "h1", text: "Slideshows"
  end

  test "should create slideshow" do
    visit slideshows_url
    click_on "New slideshow"

    fill_in "Announcements", with: @slideshow.announcements
    fill_in "Fridayc", with: @slideshow.fridayC
    fill_in "Fridayo", with: @slideshow.fridayO
    fill_in "Mondayc", with: @slideshow.mondayC
    fill_in "Mondayo", with: @slideshow.mondayO
    fill_in "Nextfridayc", with: @slideshow.nextFridayC
    fill_in "Nextfridayo", with: @slideshow.nextFridayO
    fill_in "Nextmondayc", with: @slideshow.nextMondayC
    fill_in "Nextmondayo", with: @slideshow.nextMondayO
    fill_in "Nextthursdayc", with: @slideshow.nextThursdayC
    fill_in "Nextthursdayo", with: @slideshow.nextThursdayO
    fill_in "Nexttuesdayc", with: @slideshow.nextTuesdayC
    fill_in "Nexttuesdayo", with: @slideshow.nextTuesdayO
    fill_in "Nextwednesdayc", with: @slideshow.nextWednesdayC
    fill_in "Nextwednesdayo", with: @slideshow.nextWednesdayO
    fill_in "Quote", with: @slideshow.quote
    fill_in "Thursdayc", with: @slideshow.thursdayC
    fill_in "Thursdayo", with: @slideshow.thursdayO
    fill_in "Tuesdayc", with: @slideshow.tuesdayC
    fill_in "Tuesdayo", with: @slideshow.tuesdayO
    fill_in "Wednesdayc", with: @slideshow.wednesdayC
    fill_in "Wednesdayo", with: @slideshow.wednesdayO
    click_on "Create Slideshow"

    assert_text "Slideshow was successfully created"
    click_on "Back"
  end

  test "should update Slideshow" do
    visit slideshow_url(@slideshow)
    click_on "Edit this slideshow", match: :first

    fill_in "Announcements", with: @slideshow.announcements
    fill_in "Fridayc", with: @slideshow.fridayC
    fill_in "Fridayo", with: @slideshow.fridayO
    fill_in "Mondayc", with: @slideshow.mondayC
    fill_in "Mondayo", with: @slideshow.mondayO
    fill_in "Nextfridayc", with: @slideshow.nextFridayC
    fill_in "Nextfridayo", with: @slideshow.nextFridayO
    fill_in "Nextmondayc", with: @slideshow.nextMondayC
    fill_in "Nextmondayo", with: @slideshow.nextMondayO
    fill_in "Nextthursdayc", with: @slideshow.nextThursdayC
    fill_in "Nextthursdayo", with: @slideshow.nextThursdayO
    fill_in "Nexttuesdayc", with: @slideshow.nextTuesdayC
    fill_in "Nexttuesdayo", with: @slideshow.nextTuesdayO
    fill_in "Nextwednesdayc", with: @slideshow.nextWednesdayC
    fill_in "Nextwednesdayo", with: @slideshow.nextWednesdayO
    fill_in "Quote", with: @slideshow.quote
    fill_in "Thursdayc", with: @slideshow.thursdayC
    fill_in "Thursdayo", with: @slideshow.thursdayO
    fill_in "Tuesdayc", with: @slideshow.tuesdayC
    fill_in "Tuesdayo", with: @slideshow.tuesdayO
    fill_in "Wednesdayc", with: @slideshow.wednesdayC
    fill_in "Wednesdayo", with: @slideshow.wednesdayO
    click_on "Update Slideshow"

    assert_text "Slideshow was successfully updated"
    click_on "Back"
  end

  test "should destroy Slideshow" do
    visit slideshow_url(@slideshow)
    click_on "Destroy this slideshow", match: :first

    assert_text "Slideshow was successfully destroyed"
  end
end
