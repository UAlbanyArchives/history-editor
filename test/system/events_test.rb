require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "creating a Event" do
    visit events_url
    click_on "New Event"

    fill_in "Citation description", with: @event.citation_description
    fill_in "Citation link", with: @event.citation_link
    fill_in "Citation page", with: @event.citation_page
    fill_in "Citation text", with: @event.citation_text
    fill_in "Content link", with: @event.content_link
    fill_in "Date", with: @event.date
    fill_in "Description", with: @event.description
    fill_in "Display date", with: @event.display_date
    fill_in "Thumb", with: @event.thumb
    fill_in "Title", with: @event.title
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "Citation description", with: @event.citation_description
    fill_in "Citation link", with: @event.citation_link
    fill_in "Citation page", with: @event.citation_page
    fill_in "Citation text", with: @event.citation_text
    fill_in "Content link", with: @event.content_link
    fill_in "Date", with: @event.date
    fill_in "Description", with: @event.description
    fill_in "Display date", with: @event.display_date
    fill_in "Thumb", with: @event.thumb
    fill_in "Title", with: @event.title
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "destroying a Event" do
    visit events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event was successfully destroyed"
  end
end
