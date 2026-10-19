require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "login page renders Bootstrap 5 form" do
    get new_user_session_url
    assert_response :success
    assert_select "form .mb-3 input.form-control[type=email]"
    assert_select ".form-group", count: 0
  end

  test "signing in with valid credentials" do
    post user_session_url, params: { user: { email: users(:editor).email, password: 'password123' } }
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
    assert_select "nav.navbar", text: /Logged in as\s*#{Regexp.escape(users(:editor).email)}/
  end

  test "signing in with a bad password shows an alert" do
    post user_session_url, params: { user: { email: users(:editor).email, password: 'wrong' } }
    assert_response :success
    assert_select ".alert-danger"
  end

  test "logout button signs the user out" do
    sign_in users(:editor)
    delete destroy_user_session_url
    assert_redirected_to root_url
    get events_url
    assert_redirected_to new_user_session_url
  end

  test "forgot password page renders" do
    get new_user_password_url
    assert_response :success
    assert_select "h1", text: /Forgot your password/i
  end

  test "password reset email is sent with a working reset link" do
    user = users(:editor)

    assert_emails 1 do
      post user_password_url, params: { user: { email: user.email } }
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal [user.email], mail.to
    token = mail.body.encoded[/reset_password_token=([^"&\s]+)/, 1]
    assert token, "reset link should contain a token"
    assert_match %r{/history-editor/users/password/edit}, mail.body.encoded

    get edit_user_password_url(reset_password_token: token)
    assert_response :success
    assert_select "form input[type=password]", minimum: 2

    put user_password_url, params: { user: { reset_password_token: token, password: 'newpassword1', password_confirmation: 'newpassword1' } }
    assert_response :redirect
    assert user.reload.valid_password?('newpassword1')
  end

  test "password reset shows validation errors with the error helper" do
    user = users(:editor)
    token = user.send_reset_password_instructions
    put user_password_url, params: { user: { reset_password_token: token, password: 'abc123', password_confirmation: 'different' } }
    assert_response :success
    assert_select ".alert-danger li"
  end
end
