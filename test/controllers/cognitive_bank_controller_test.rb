require 'test_helper'

class CognitiveBankControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select 'title', 'Cognitive Bank'
  end
end
