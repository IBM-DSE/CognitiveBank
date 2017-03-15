class MlScoringService < ApplicationRecord
  
  def get_token
    response = RestClient.post(ldap_url, creds.to_json, content_type: :json)
    JSON.parse(response)['token']
  end
  
  def get_score
    token = get_token
    post_to_scoring_ml token
  end
  
  def test_ldap
    token = get_token
    token.is_a?(String) and token.start_with?(TOKEN_PREFIX)
  end
  
  def test_score
    score = get_score
    score.is_a?(String) and token.start_with?(TOKEN_PREFIX)
  end
  
  private
  
  TOKEN_PREFIX = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'
  SCORING_ATTRS = %w(AGE ACTIVITY EDUCATION SEX STATE NEGTWEETS INCOME)
  SAMPLE_RECORD = [41, 4, 3, 'M', 'TX', 12, 316530]
  
  def ldap_url
    "http://#{self.hostname}:#{self.ldap_port}/v2/identity/ldap"
  end
  
  def creds
    { username: username, password: password }
  end
  
  def scoring_url
    "http://#{self.hostname}:#{self.scoring_port}/wml/scoring/spark/deployments/#{self.deployment}/predict"
  end
  
  def post_to_scoring_ml(token)
    puts 'Posting to endpoint '+scoring_url
    headers = { :content_type => 'application/json', :Authorization => 'Bearer '+token }
    body    = { 'Record': SAMPLE_RECORD }.to_json
    puts headers
    puts body
    begin
      response = RestClient.post scoring_url, body, headers
      puts 'Scoring request successful!'
      JSON.parse(response)
    rescue Exception => e
      puts 'ERROR: '+e.message
      false
    end
  end

end
