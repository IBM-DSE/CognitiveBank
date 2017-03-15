class MlScoringService < ApplicationRecord
  
  def get_token
    response = RestClient.post(ldap_url, creds.to_json, content_type: :json)
    JSON.parse(response)['token']
  end
  
  def test_ldap
    token = get_token
    token.is_a?(String) and token.start_with?(TOKEN_PREFIX)
  end
  
  private

  TOKEN_PREFIX = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'

  def ldap_url
    "http://#{self.hostname}:#{self.ldap_port}/v2/identity/ldap"
  end

  def creds
    { username: username, password: password }
  end

end
