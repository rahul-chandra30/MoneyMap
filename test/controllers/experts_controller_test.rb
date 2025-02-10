require "test_helper"

class ExpertsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get experts_new_url
    assert_response :success
  end

  test "should get create" do
    get experts_create_url
    assert_response :success
  end
end
