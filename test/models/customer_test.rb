require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  def setup
    @customer = customers(:bruce)

    @bad_hostname_scoring_service  = ml_scoring_services :wsc_gateway_bad_hostname
    @bad_ldap_port_scoring_service = ml_scoring_services :wsc_gateway_bad_ldap_port
    @bad_scoring_port_service      = ml_scoring_services :wsc_gateway_bad_scoring_port
    @scoring_service               = ml_scoring_services :wsc_gateway
  end
  
  test 'bad_scoring_hostname_call' do
    @customer.update_churn
  end
  
  # test 'context should be read/write-able' do
  #   @customer.update_attribute :context, {foo: 'bar'}
  #   assert_equal @customer.context, {foo: 'bar'}
  # end

end
