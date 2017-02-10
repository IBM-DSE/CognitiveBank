class Customer < ApplicationRecord
  belongs_to :user
  
  # TODO: point from customer to twitter_personality
  has_one :twitter_personality
  has_many :transactions
  has_many :messages
  
  serialize :context, JSON
  
  SCORING_ML_URL      = 'https://prod-scoring-ml.spark.bluemix.net:32768/v1/score/581'
  SCORING_ML_RESOURCE = RestClient::Resource.new SCORING_ML_URL
  
  def get_churn(debug=false)
    if debug
      puts ' '
      puts 'Fetching churn probability from MLz churn model.'
      puts 'Sending cutsomer attributes to churn scoring: '
      puts churn_attrs.to_s
    end
    if Rails.env.production?
      response = post_to_scoring_ml churn_attrs.values
      process_json(response)
    else
      load_sample_ml_result
    end
  end
  
  def start_conversation
    # Send empty string to Watson Conversation
    if messages.empty?
      puts ' '
      puts 'Starting conversation with the customer...'
      Message.send_to_watson_conversation('', self)
    end
  end
  
  def name
    self.user.name
  end
  
  def twitter_id
    self.twitter_personality.username
  end
  
  def gender
    self.gender ? 'Male' : 'Female'
  end
  
  def self.print_churn(churn)
    puts ' '
    puts 'Customer churn result: '
    churn.each do |k,v|
      puts "  #{k.to_s.humanize}: #{v}"
    end
  end
  
  private

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
  
  def process_json(json)
    body        = JSON.parse(json)
    result = body['result']
    churn = result['prediction'] == 1.0
    prob = result['probability']['values'][result['prediction'].to_i]
    {churn: churn, probability: (prob*100.0).round(2).to_s+'%'}
  end

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

  def load_sample_ml_result
    file = File.read('db/churn_result.json')
    process_json(file)
  end
  
  def sample_input
    {
        sex: 'F',
        age: 38,
        education: 2,
        investment: 114368,
        income: 3852862,
        activity: 5,
        yrly_amt: 700259,
        avg_daily_tx: 0.0,
        yrly_tx: 335,
        avg_tx_amt: 2090,
        negtweets: 3
    }
  end

end
