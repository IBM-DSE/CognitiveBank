require 'test_helper'

class ConversationTest < ActionDispatch::IntegrationTest
  
  INTRO = "Hi there, I\\'m the Cognitive Bank Virtual Assistant! I can help you find a good offer. Interested?"
  
  def setup
    @user = users(:bruce)
  end
  
  test 'good conversation' do
    log_in_as(@user, password: 'password')
    post '/messages', params: { message: {content: '', context: ''} }, xhr: true, headers: { accept: 'text/javascript' }
    assert_response :success
    assert_select 'img'
    assert_includes @response.body, 'watson-message'
    assert_includes @response.body, INTRO.html_safe
  end

  test 'bad conversation' do
    MlScoringService.set_main ml_scoring_services(:wsc_gateway_bad_hostname)
    log_in_as(@user, password: 'password')
    post '/messages', params: { message: {content: '', context: ''} }, xhr: true, headers: { accept: 'text/javascript' }
    assert_response :success
    assert_select 'img'
    assert_includes @response.body, 'watson-message'
    assert_includes @response.body, INTRO.html_safe
    MlScoringService.set_main ml_scoring_services(:wsc_gateway)
  end
  
end
