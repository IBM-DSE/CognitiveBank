require 'test_helper'

class CognitiveBankControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', 'Cognitive Bank'
    assert_select 'h1', 'Cognitive Bank'
    assert_select 'p', 'Giving you a smarter banking experience with IBM Watson and IBM Machine Learning for z/OS'
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', profile_path, count: 0
  end
end
