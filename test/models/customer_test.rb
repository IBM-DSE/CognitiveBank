require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  def setup
    @customer = customers(:bruce)
  end
  
  test 'bad_scoring_hostname_call' do
    set_main_ml_service :wsc_gateway_bad_hostname
    assert_no_change(@customer, :updated_at) { @customer.update_churn }
  end

  test 'bad_ldap_port_scoring_call' do
    set_main_ml_service :wsc_gateway_bad_ldap_port
    assert_no_change(@customer, :updated_at) { @customer.update_churn }
  end

  test 'bad_scoring_port_call' do
    set_main_ml_service :wsc_gateway_bad_scoring_port
    assert_no_change(@customer, :updated_at) { @customer.update_churn }
  end

  test 'good_scoring_call' do
    set_main_ml_service :wsc_gateway
    assert_change(@customer, :updated_at) { @customer.update_churn }
  end
  
end
