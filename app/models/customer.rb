class Customer < ApplicationRecord
  belongs_to :user

  has_many :transactions
  has_many :messages

  serialize :context, Hash
  
  SCORING_ML_URL      = 'https://prod-scoring-ml.spark.bluemix.net:32768/v1/score/581'
  SCORING_ML_RESOURCE = RestClient::Resource.new SCORING_ML_URL
  
  def get_churn
    response = post_to_scoring_ml ['F', 38, 2, 114368, 3852862, 5, 700259, 0.0, 335, 2090, 3]
    full_result = eval(response.body)[:result]
    full_result.slice :prediction, :raw_prediction, :probability
  end
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
  
  def post_to_scoring_ml(record)
    
    headers = { :content_type => 'application/json', :Authorization => '5tJjGrhtD1KRyGgv0oPufA==' }
    body = { 'record': record }.to_json
    begin
      SCORING_ML_RESOURCE.post(body, headers)
    rescue Exception => ex
      puts "ERROR: #{ex.response}"
      puts "Scoring Endpoint = #{SCORING_ML_RESOURCE}"
      puts "Body sent to Scoring: #{body}"
      raise ex
    end
    
  end
  
  def gender
    self.gender ? 'Male' : 'Female'
  end
end
