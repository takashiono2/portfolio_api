require 'test_helper'

class PrivateControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get private" do
    get private_controller_private_url
    assert_response :success
  end

end
