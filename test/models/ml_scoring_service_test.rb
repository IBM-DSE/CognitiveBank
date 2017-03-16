require 'test_helper'

class MlScoringServiceTest < ActiveSupport::TestCase
  
  TOKEN_PREFIX = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'
  SCORING_ATTRS = %w(AGE ACTIVITY EDUCATION SEX STATE NEGTWEETS INCOME)
  
  def setup
    @scoring_service               = ml_scoring_services :wsc_gateway
    @bad_hostname_scoring_service  = ml_scoring_services :wsc_gateway_bad_hostname
    @bad_ldap_port_scoring_service = ml_scoring_services :wsc_gateway_bad_ldap_port
    @bad_scoring_port_service      = ml_scoring_services :wsc_gateway_bad_scoring_port
    
    @bruce = customers :bruce
  end
  
  test 'fetch_ldap_token' do
    token = @scoring_service.instance_eval{get_token}
    assert_kind_of String, token
    assert token.start_with? TOKEN_PREFIX
  end

  test 'fetch_ml_score' do
    score = MlScoringService.get_score @bruce
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

  test 'bad_hostname_fetch_ml_score' do
    score = @bad_hostname_scoring_service.get_score @bruce
    assert_kind_of FalseClass, score
  end
  
  test 'bad_ldap_port_fetch_ml_score' do
    score = @bad_ldap_port_scoring_service.get_score @bruce
    assert_kind_of FalseClass, score
  end

  test 'bad_scoring_port_fetch_ml_score' do
    score = @bad_scoring_port_service.get_score @bruce
    assert_kind_of FalseClass, score
  end
  
end
