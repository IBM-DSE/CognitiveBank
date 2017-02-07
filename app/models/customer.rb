class Customer < ApplicationRecord
  belongs_to :user
  
  # TODO: point from customer to twitter_personality
  has_one :twitter_personality
  has_many :transactions
  has_many :messages
  
  serialize :context, JSON
  
  SCORING_ML_URL      = 'https://prod-scoring-ml.spark.bluemix.net:32768/v1/score/581'
  SCORING_ML_RESOURCE = RestClient::Resource.new SCORING_ML_URL
  
  #where:
  #SEX: F
  #AGE: 38
  #EDUCATION: 2
  #INVESTMENT: 114368
  #INCOME: 3852862
  #ACTIVITY: 5
  #YRLY_AMT: 700259
  #AVG_DAILY_TX: 0.0
  #YRLY_TX: 335
  #AVG_TX_AMT: 2090
  #NEGTWEETS: 3
  def churn_attrs
    self.attributes.slice(
        'sex',
        'age',
        'education',
        'investment',
        'income',
        'activity',
        'yrly_amt',
        'avg_daily_tx',
        'yrly_tx',
        'avg_tx_amt',
        'negtweets'
    )
  end
  
  def get_churn
    response = post_to_scoring_ml self.churn_attrs.values
    extract_from_json(response)
  end
  
  def load_sample_ml_result
    file = File.read('db/churn_result.json')
    extract_from_json(file)
  end
  
  
  def start_conversation
    # Send empty string to Watson Conversation
    Message.send_to_watson_conversation('', self) if messages.empty?
  end
  
  def post_to_scoring_ml(record)
    
    headers = { :content_type => 'application/json', :Authorization => '5tJjGrhtD1KRyGgv0oPufA==' }
    body    = { 'record': record }.to_json
    begin
      SCORING_ML_RESOURCE.post(body, headers)
    rescue Exception => ex
      puts "ERROR: #{ex.response}"
      puts "Scoring Endpoint = #{SCORING_ML_RESOURCE}"
      puts "Body sent to Scoring: #{body}"
      raise ex
    end
  
  end
  
  def twitter_id
    self.twitter_personality.username
  end
  
  def gender
    self.gender ? 'Male' : 'Female'
  end
  
  private
  
  def extract_from_json(json)
    body        = JSON.parse(json)
    full_result = body['result']
    full_result.slice 'prediction', 'raw_prediction', 'probability'
  end

end
