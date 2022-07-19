require "test_helper"

class Users::PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get users_preferences_edit_url
    assert_response :success
  end
end
