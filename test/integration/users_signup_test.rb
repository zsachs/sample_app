require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
								email: "user@invalid",
								password: "foo",
								password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation div', "The form contains 4 errors."
    assert_select 'div#error_explanation' do |elements|
      elements.each do |element|
        assert_select element, 'li', 4
        assert_select element, 'li', "Name can't be blank"
        assert_select element, 'li', "Email is invalid"
        assert_select element, 'li',
				"Password confirmation doesn't match Password"
        assert_select element, 'li',
				"Password is too short (minimum is 6 characters)"
      end
    end
    assert_select 'div.field_with_errors label', 4
    assert_select 'div.field_with_errors input', 4
    assert_select 'div.field_with_errors input#user_name'
    assert_select 'div.field_with_errors input#user_email'
    assert_select 'div.field_with_errors input#user_password'
    assert_select 'div.field_with_errors input#user_password_confirmation'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Example User",
											email: "user@example.com",
											password: "password",
											password_confirmation: "password" }
    end
    assert_template 'users/show'
  end
end
