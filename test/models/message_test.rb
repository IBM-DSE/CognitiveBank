require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @customer    = customers(:bruce)
    @message = @customer.messages.build(content: 'Lorem ipsum')
  end
  
  test 'should be valid' do
    assert @message.valid?
  end
  
  test 'customer id should be present' do
    @message.customer_id = nil
    assert_not @message.valid?
  end
  
  test 'content should be present' do
    @message.content = '   '
    assert_not @message.valid?
  end
  
end
