require 'test_helper'

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subject = subjects(:one)
    sign_in users(:editor)
  end

  test "should get index" do
    get subjects_url
    assert_response :success
  end

  test "should get new" do
    get new_subject_url
    assert_response :success
    assert_select "form input[name='subject[name]'].form-control"
  end

  test "should show subject with delete form" do
    get subject_url(@subject)
    assert_response :success
    assert_select "form[data-confirm] button.btn-danger", text: "Destroy"
  end

  test "should get edit" do
    get edit_subject_url(@subject)
    assert_response :success
    assert_select "form[data-confirm] button.btn-danger", text: "Destroy"
  end

  # The controller keeps config/subjects.yml in sync relative to the working directory,
  # so run writes from an empty directory to leave the real file untouched.
  test "should create, update and destroy subject" do
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        assert_difference('Subject.count') do
          post subjects_url, params: { subject: { name: "Gamma", representative_media: "" } }
        end
        subject = Subject.find_by!(name: "Gamma")
        assert_redirected_to subject_url(subject)

        patch subject_url(subject), params: { subject: { name: "Delta", representative_media: "" } }
        assert_redirected_to subject_url(subject)
        assert_equal "Delta", subject.reload.name

        assert_difference('Subject.count', -1) do
          delete subject_url(subject)
        end
        assert_redirected_to subjects_url
      end
    end
  end
end
