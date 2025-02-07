require "test_helper"

class ExpendituresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get expenditures_create_url
    assert_response :success
  end

  test "should get update" do
    get expenditures_update_url
    assert_response :success
  end

  test "should get show" do
    get expenditures_show_url
    assert_response :success
  end
end
