require "test_helper"

class Ap::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get ap_v1_users_create_url
    assert_response :success
  end
end
