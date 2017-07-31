class MlScoringService < ApplicationRecord
  after_save { MlScoringService.init_main }

  def self.init_main
    @@main ||= MlScoringService.first
  end
  
  def self.set_main(service)
    @@main = service
  end

  def self.get_main
    @@main
  end
  
  def self.get_score(customer)
    MlScoringService.init_main
    @@main.get_score customer
  end
  
  def get_score(customer)
    token          = get_token
    return false unless token
    customer_attrs = customer.attributes.slice(*SCORING_ATTRS).values
    post_to_scoring_ml token, customer_attrs
  end
  
  def test_ldap
    token = get_token
    valid_token(token)
  end
  
  def test_score
    score = post_to_scoring_ml get_token, SAMPLE_RECORD
    score.is_a?(Hash) and
        score.keys.include? 'prediction' and
        [1, 0].include? score['prediction'] and
        score.keys.include? 'probability' and
        (0..1) === score['probability']['values'][score['prediction']]
  end
  
  private
  
  TOKEN_PREFIX  = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9'
  SCORING_ATTRS = %w(age activity education sex state negtweets income)
  SAMPLE_RECORD = [26, 2, 3, 'M', 'NY', 0, 483620]
  SCORING_CALL_TIMEOUT = (ENV['ML_SCORING_TIMEOUT'] || 2).to_i
  
  def ldap_url
    "http://#{self.hostname}:#{self.ldap_port}/v2/identity/ldap"
  end
  
  def creds
    { username: username, password: password }
  end
  
  def scoring_url
    "http://#{self.hostname}:#{self.scoring_port}/wml/scoring/spark/deployments/#{self.deployment}/predict"
  end
  
  def get_token
    begin
      response = RestClient::Request.execute method: :post, url: ldap_url, payload: creds.to_json, headers: {content_type: :json}, 
                                             read_timeout: SCORING_CALL_TIMEOUT, open_timeout: SCORING_CALL_TIMEOUT
      JSON.parse(response)['token']
    rescue => e
      handle_error e
    end
  end
  
  def post_to_scoring_ml(token, customer_attrs)
    puts ' '
    puts 'Fetching churn probability from MLz churn model.'
    puts 'Sending customer attributes to churn scoring: '
    puts customer_attrs.to_s
    puts 'Posting to endpoint '+scoring_url
    headers = { :content_type => 'application/json', :Authorization => 'Bearer '+token }
    body    = { 'Record': customer_attrs }.to_json
    puts headers
    puts body
    begin
      response = RestClient::Request.execute method: :post, url: scoring_url, payload: body, headers: headers,
                                             read_timeout: SCORING_CALL_TIMEOUT, open_timeout: SCORING_CALL_TIMEOUT
      puts 'Scoring request successful!'
      JSON.parse(response)
    rescue => e
      handle_error e
    end
  end
  
  def handle_error(e)
    STDERR.puts "ML Scoring ERROR: #{e}"
    STDERR.puts e.backtrace.select { |l| l.start_with? Rails.root.to_s }
    false
  end
  
  def valid_token(token)
    token.is_a?(String) and token.start_with?(TOKEN_PREFIX)
  end

end
