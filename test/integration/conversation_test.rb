require 'test_helper'

class ConversationTest < ActionDispatch::IntegrationTest
  
  INTRO      = "Hi there, I\\'m the Cognitive Bank Virtual Assistant! I can help you find a good offer. Interested?"
  BAD_CONFIG = "Oops! Looks like I haven\\'t been configured correctly to speak with Watson."
  
  def setup
    @user = users(:bruce)
  end

  test 'bad socring service conversation' do
    set_main_ml_service :wsc_gateway_bad_hostname
    log_in_as(@user, password: 'password')
    post '/messages', params: { message: { content: '', context: '' } }, xhr: true, headers: { accept: 'text/javascript' }
    assert_response :success
    assert_select 'img'
    assert_includes @response.body, 'watson-message'
    assert_includes @response.body, INTRO.html_safe
    set_main_ml_service :wsc_gateway
  end
  
  test 'bad conversation workspace' do
    good_workspace      = ENV['WORKSPACE_ID']
    ENV['WORKSPACE_ID'] = 'FOOBAR'
    log_in_as(@user, password: 'password')
    post '/messages', params: { message: { content: '', context: '' } }, xhr: true, headers: { accept: 'text/javascript' }
    assert_response :success
    assert_select 'img'
    assert_includes @response.body, 'watson-message'
    assert_includes @response.body, BAD_CONFIG.html_safe
    ENV['WORKSPACE_ID'] = good_workspace
  end
  
  test 'good conversation' do
    log_in_as(@user, password: 'password')
    post '/messages', params: { message: { content: '', context: '' } }, xhr: true, headers: { accept: 'text/javascript' }
    assert_response :success
    assert_select 'img'
    assert_includes @response.body, 'watson-message'
    assert_includes @response.body, INTRO.html_safe
  end
  
end
