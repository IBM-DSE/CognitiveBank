# frozen_string_literal: true

class MlScoringService < ApplicationRecord
  validates :hostname, presence: true
  validates :username, presence: true
  validates :password, presence: true
  validates :deployment, presence: true
  validate :test_ml_scoring_service

  def self.main
    MlScoringService.first
  end
  
  def self.detect_wml_services
    if ENV['VCAP_SERVICES']
      convo_creds = CF::App::Credentials.find_by_service_label('pm-20')
      if convo_creds
        hostname = 'ibm-watson-ml.mybluemix.net'
        username = convo_creds['username']
        password = convo_creds['password']
        
        # detect first deployment
        service = IBM::ML::Cloud.new username, password
        deployments = service.deployments

        name = 'WML Service'
        deployment = nil
        if deployments['count'].positive?
          deployments['resources'].each do |dep|
            name = dep['entity']['name'].downcase
            if name.include?('churn')
              deployment = dep['metadata']['guid']
              name = dep['entity']['name']  
            end
          end
        end
        
        return new(name: name, hostname: hostname, username: username, password: password, deployment: deployment)
      end
    end
    new
  end
  
  def self.get_result(customer)
    puts
    hostname = main ? main.hostname : 'default'
    puts "Scoring against #{hostname}..."
    main&.process_score main&.get_score(customer)
  end

  def get_score(customer)
    case type
    when CLOUD
      @service.score deployment, customer.attributes.slice(*SCORING_ATTRS)
    when LOCAL
      record = customer.attributes.slice(*SCORING_ATTRS).map { |k, v| [k.upcase, v] }.to_h
      @service.score deployment, record
    when MLZOS
      get_score_mlz(customer)
    end
  end

  def process_score(score)
    case type
    when CLOUD, LOCAL
      {
        churn_prediction: @service.query_score(score, 'prediction'),
        churn_probability: @service.query_score(score, 'probability')[1],
        ml_scoring_service_id: id
      }
    when MLZOS
      process_score_mlz(score)
    end
  end
  
  def get_score_mlz(customer)
    token = get_token
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
    score.is_a?(Hash) && (
      (type == MLZOS) && score.keys.include?('values') &&
        [1, 0].include?(score['prediction']) &&
        score.keys.include?('probability') &&
        ((0..1) === score['probability']['values'][score['prediction']])
    ) || (
      @service.query_score(score, 'prediction') && 
      @service.query_score(score, 'probability')[0]
    )
  end

  def self.standard_attrs
    %w[name hostname username password deployment]
  end

  def self.mlz_attrs
    %w[ldap_port scoring_hostname scoring_port]
  end
  
  def display_name
    name || hostname
  end
  
  private
  
  CLOUD = 1
  LOCAL = 2
  MLZOS = 3
  
  def test_ml_scoring_service
    if hostname.present? && username.present? && password.present?
      test_score if test_ldap && deployment.present?
    end
    false
  end
  
  def type
    if scoring_port
      MLZOS
    elsif hostname == 'ibm-watson-ml.mybluemix.net'
      ml_cloud
      CLOUD
    else
      ml_local
      LOCAL
    end
  end

  def ml_local
    @service = IBM::ML::Local.new hostname, username, password
  end

  def ml_cloud
    @service = IBM::ML::Cloud.new username, password
  end
  
  SCORING_ATTRS = %w[age activity education gender state negtweets income].freeze
  SAMPLE_RECORD = Customer.first
  SCORING_CALL_TIMEOUT = (ENV['ML_SCORING_TIMEOUT'] || 3).to_i
  
  def ldap_url
    "http://#{hostname}:#{ldap_port}/v2/identity/ldap"
  end
  
  def creds
    { username: username, password: password }
  end
  
  def scoring_url
    "http://#{scoring_hostname || hostname}:#{scoring_port}/iml/scoring/spark/deployments/#{deployment}/predict"
  end

  def get_token
    
    case type
    when CLOUD, LOCAL
      @service.fetch_token
    when MLZOS
      get_token_mlz
    end
  rescue RuntimeError => e
    if e.message == 'Net::HTTPNotFound'
      errors.add(:hostname, e.message.demodulize)
    else
      errors.add(:username, e.message.demodulize)
      errors.add(:password, e.message.demodulize)
    end
  rescue SocketError => e
    errors.add(:hostname, e.message)
    
  end
  
  def get_token_mlz
    
    response = RestClient::Request.execute method: :post, url: ldap_url, payload: creds.to_json, headers: { content_type: :json }, 
                                           read_timeout: SCORING_CALL_TIMEOUT, open_timeout: SCORING_CALL_TIMEOUT
    JSON.parse(response)['token']
  rescue => e
    handle_error e
    
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
    STDERR.puts e.backtrace.select { |l| l.start_with? Rails.root.to_s }[0]
    false
  end
  
  def valid_token(token)
    token.is_a?(String) && (token.length > 256)
  end
end
