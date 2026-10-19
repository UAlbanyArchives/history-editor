require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    sign_in users(:editor)
  end

  test "redirects to login when signed out" do
    sign_out users(:editor)
    get events_url
    assert_redirected_to new_user_session_url
  end

  test "should get index with Bootstrap 5 layout" do
    get events_url
    assert_response :success
    assert_select "nav.navbar button[data-bs-toggle=collapse]"
    assert_select "nav.navbar a[data-bs-toggle=dropdown]"
    assert_select "nav.navbar form[action$='/users/sign_out'] button", text: "Logout"
    assert_select "[data-toggle], [data-target]", count: 0
  end

  test "index paginates with Bootstrap 5 markup" do
    Event.insert_all((1..35).map { |i| { title: "Bulk #{i}", description: "d", date: Date.new(2021, 1, 1) } })
    get events_url
    assert_response :success
    assert_select "nav[aria-label=Pagination] ul.pagination li.page-item.active"
    assert_select "nav[aria-label=Pagination] a.page-link[href*='page=2']"
  end

  test "should get new" do
    get new_event_url
    assert_response :success
    assert_select "form input[name='event[title]'].form-control"
    assert_select "a.add_fields"
  end

  test "should create event with a citation" do
    assert_difference(['Event.count', 'Citation.count']) do
      post events_url, params: { event: {
        title: "Brand new", description: "Desc", date: "2021-02-03", representative_media: "",
        subject_ids: [subjects(:one).id],
        citations_attributes: { "0" => { link: "https://archives.albany.edu/description/catalog/apap103aspace_89abcdef", text: "Cite" } }
      } }
    end
    assert_redirected_to event_url(Event.find_by!(title: "Brand new"))
    assert_equal [subjects(:one)], Event.find_by!(title: "Brand new").subjects
  end

  test "should re-render form on invalid create" do
    assert_no_difference('Event.count') do
      post events_url, params: { event: { title: "", description: "", representative_media: "" } }
    end
    assert_response :success
    assert_select "#error_explanation"
  end

  test "should show event with delete form" do
    get event_url(@event)
    assert_response :success
    assert_select "form[data-confirm][action=?] button.btn-danger", event_path(@event), text: "Destroy"
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { title: "Renamed", representative_media: "" } }
    assert_redirected_to event_url(@event)
    assert_equal "Renamed", @event.reload.title
    assert_equal users(:editor).id, @event.updated_by
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end
    assert_redirected_to events_url
  end

  test "records paper trail versions" do
    assert_difference('PaperTrail::Version.count') do
      @event.update!(title: "Versioned")
    end
    assert_equal "First event", @event.versions.last.reify.title
  end
end
