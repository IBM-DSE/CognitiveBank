require 'test_helper'

class MlScoringServiceTest < ActiveSupport::TestCase
  
  TOKEN_PREFIX = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'
  SCORING_ATTRS = %w(AGE ACTIVITY EDUCATION SEX STATE NEGTWEETS INCOME)
  
  def setup
    @scoring_service = ml_scoring_services :wsc_gateway
  end
  
  test 'fetch_ldap_token' do
    token = @scoring_service.get_token
    assert_kind_of String, token
    assert token.start_with? TOKEN_PREFIX
  end

  test 'fetch_ml_score' do
    score = @scoring_service.get_score
    assert_not_kind_of FalseClass, score
    assert_kind_of Hash, score
    SCORING_ATTRS.each do |attr|
      assert_includes score.keys, attr
    end
    
    assert_includes score.keys, 'prediction'
    assert_includes [1,0], score['prediction']
    
    assert_includes score.keys, 'probability'
    score['probability']['values'].each do |val|
      assert (0..1) === val
    end
  end
  
end
