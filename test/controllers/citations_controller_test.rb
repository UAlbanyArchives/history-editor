require 'test_helper'

class CitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @citation = citations(:one)
    sign_in users(:editor)
  end

  test "should get index with delete form" do
    get citations_url
    assert_response :success
    assert_select "form[data-confirm] button", text: "Destroy", minimum: 1
  end

  test "should get new" do
    get new_citation_url
    assert_response :success
    assert_select "form input[name='citation[link]'].form-control"
  end

  test "should create citation" do
    assert_difference('Citation.count') do
      post citations_url, params: { citation: { link: "https://archives.albany.edu/description/catalog/apap104aspace_deadbeef", text: "New" } }
    end
    assert_redirected_to citation_url(Citation.last)
  end

  test "should reject citation with a bad link" do
    assert_no_difference('Citation.count') do
      post citations_url, params: { citation: { link: "https://example.com/nope" } }
    end
    assert_response :success
  end

  test "should show citation" do
    get citation_url(@citation)
    assert_response :success
  end

  test "should get edit" do
    get edit_citation_url(@citation)
    assert_response :success
  end

  test "should update citation" do
    patch citation_url(@citation), params: { citation: { text: "Updated" } }
    assert_redirected_to citation_url(@citation)
    assert_equal "Updated", @citation.reload.text
  end

  test "should destroy citation" do
    assert_difference('Citation.count', -1) do
      delete citation_url(@citation)
    end
    assert_redirected_to citations_url
  end
end
