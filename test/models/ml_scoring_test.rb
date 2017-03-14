require 'test_helper'

class MlScoringTest < ActiveSupport::TestCase
  
  def setup
    @customer = customers(:bruce)
  end
  
  test 'Customer churn prediction' do
    @customer.update_churn
    [true, false].include? @customer.churn_prediction
    assert_kind_of Float, @customer.churn_probability
  end
  
  # test 'LDAP call should work' do
  #   ldap_response = @churn.update_token
  #   assert_kind_of Hash, ldap_response
  # end
  
end