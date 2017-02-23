class MlScoringService < ApplicationRecord
  
  def ldap_url
    "http://#{self.hostname}:#{self.ldap_port}/v2/identity/ldap"
  end
  
  def creds
    { username: username, password: password }
  end
  
  def get_token
    response = RestClient.post(ldap_url, creds.to_json, content_type: :json)
    JSON.parse(response)['token']
  end

end
