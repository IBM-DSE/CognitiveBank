require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user    = users(:michael)
    @message = @user.messages.build(content: 'Lorem ipsum')
  end
  
  test 'should be valid' do
    assert @message.valid?
  end
  
  test 'user id should be present' do
    @message.user_id = nil
    assert_not @message.valid?
  end
  
  test 'content should be present' do
    @message.content = '   '
    assert_not @message.valid?
  end
  
  test 'content should be at most 140 characters' do
    @message.content = 'a' * 141
    assert_not @message.valid?
  end
end
