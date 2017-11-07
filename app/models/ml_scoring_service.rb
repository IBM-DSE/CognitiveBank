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
    puts
    hostname = @@main ? @@main.hostname : 'default'
    puts "Scoring against #{hostname}..."
    @@main.get_score customer if @@main
  end

  def self.process_score(score)
    MlScoringService.init_main
    if @@main
      @@main.process_score score
    else
      process_score_mlz score
    end
  end
  
  def get_score(customer)
    case type
      when CLOUD
        ml_cloud.score self.deployment, customer.attributes.slice(*SCORING_ATTRS)
      when LOCAL
        record = customer.attributes.slice(*SCORING_ATTRS).map { |k,v| [k.upcase, v] }.to_h
        ml_local.score self.deployment, record
      when MLZOS
        get_score_mlz(customer)
    end
  end

  def process_score(score)
    case type
      when CLOUD, LOCAL
        {
          churn_prediction: @service.query_score(score, 'prediction'),
          churn_probability: @service.query_score(score, 'probability')[1]
        }
      when MLZOS
        self.process_score_mlz(score)
    end
  end
  
  def get_score_mlz(customer)
    token          = get_token
    return false unless token
    customer_attrs = customer.attributes.slice(*SCORING_ATTRS).values
    post_to_scoring_ml token, customer_attrs
  end

  def self.process_score_mlz(score)
    churn   = score['prediction'] == 1.0
    prob    = score['probability']['values'][score['prediction']]
    { churn_prediction: churn, churn_probability: prob }
  end
  
  def test_ldap
    token = get_token
    valid_token(token)
  end
  
  def test_score
    score = get_score SAMPLE_RECORD
    score.is_a?(Hash) and (
      type == MLZOS and score.keys.include? 'values' and
        [1, 0].include? score['prediction'] and
        score.keys.include? 'probability' and
        (0..1) === score['probability']['values'][score['prediction']]
    ) or (
      @service.query_score(score, 'prediction') and 
      @service.query_score(score, 'probability')[0]
    )
  end

  def self.standard_attrs
    %w(name hostname username password deployment)
  end

  def self.mlz_attrs
    %w(ldap_port scoring_hostname scoring_port)
  end
  
  private
  
  CLOUD = 1
  LOCAL = 2
  MLZOS = 3
  
  def type
    if scoring_port
      MLZOS
    elsif hostname == 'ibm-watson-ml.mybluemix.net'
      CLOUD
    else
      LOCAL
    end
  end

  def ml_local
    @service = IBM::ML::Local.new hostname, username, password
  end

  def ml_cloud
    @service = IBM::ML::Cloud.new username, password
  end
  
  SCORING_ATTRS = %w(age activity education sex state negtweets income)
  SAMPLE_RECORD = Customer.first
  SCORING_CALL_TIMEOUT = (ENV['ML_SCORING_TIMEOUT'] || 3).to_i
  
  def ldap_url
    "http://#{self.hostname}:#{self.ldap_port}/v2/identity/ldap"
  end
  
  def creds
    { username: username, password: password }
  end
  
  def scoring_url
    "http://#{self.scoring_hostname || self.hostname}:#{self.scoring_port}/iml/scoring/spark/deployments/#{self.deployment}/predict"
  end

  def get_token
    case type
      when CLOUD
        ml_cloud.fetch_token
      when LOCAL
        ml_local.fetch_token
      when MLZOS
        get_token_mlz
    end
  end
  
  def get_token_mlz
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
    STDERR.puts e.backtrace.select{ |l| l.start_with? Rails.root.to_s }[0]
    false
  end
  
  def valid_token(token)
    token.is_a?(String) and token.length > 256
  end

end
