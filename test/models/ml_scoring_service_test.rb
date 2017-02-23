require 'test_helper'

class ML_ScoringServiceTest < ActiveSupport::TestCase
  
  TOKEN_PREFIX = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'
  
  def setup
    @scoring_service = ml_scoring_services :svl_gateway
  end
  
  test 'ldap_token_fetch' do
    token = @scoring_service.get_token
    assert_kind_of String, token
    assert token.start_with? TOKEN_PREFIX
  end
  
end
