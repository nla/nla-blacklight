require "test_helper"

class Users::PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_preferences_index_url
    assert_response :success
  end

  test "should get edit" do
    get users_preferences_edit_url
    assert_response :success
  end
end
