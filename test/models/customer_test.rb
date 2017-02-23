require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  def setup
    @customer = customers(:bruce)
  end
  
  # test 'context should be read/write-able' do
  #   @customer.update_attribute :context, {foo: 'bar'}
  #   assert_equal @customer.context, {foo: 'bar'}
  # end

end
