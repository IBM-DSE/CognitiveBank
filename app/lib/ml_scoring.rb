class ML_Scoring
  
  attr_reader :result
  
  def initialize(customer)
    @customer_attrs = customer.attributes.slice(*SCORING_ATTRS).values
    puts ' '
    puts 'Fetching churn probability from MLz churn model.'
    puts 'Sending customer attributes to churn scoring: '
    puts @customer_attrs.to_s
    
    post_to_scoring_ml
    
    print_churn_result
  end
  
  def to_h
    @result
  end
  
  def to_s
    @result.to_s
  end
  
  private
  
  SCORING_ATTRS = %w(age activity education sex state negtweets income)

  ML_SCORING_RESOURCE = RestClient::Resource.new ENV['ML_SCORING_URL'],
                                                 :read_timeout => ENV['ML_SCORING_TIMEOUT'].to_i || 2,
                                                 :open_timeout => ENV['ML_SCORING_TIMEOUT'].to_i || 2
  
  def post_to_scoring_ml
    puts 'Posting to endpoint '+ML_SCORING_RESOURCE.url
    headers = { :content_type => 'application/json', :Authorization => ENV['ML_SCORING_AUTH'] }
    body    = { 'Record': @customer_attrs }.to_json
    begin
      puts headers
      puts body
      request = ML_SCORING_RESOURCE.post(body, headers)
      puts 'Scoring request successful!'
      process_json request
    rescue Exception => e
      puts 'ERROR: '+e.message
      load_sample_ml_result
    end
  end
  
  def process_json(json)
    result  = JSON.parse(json)
    puts result
    churn   = result['prediction'] == 1.0
    prob    = result['probability']['values'][result['prediction'].to_i]
    @result = { prediction: churn, probability: (prob*100.0).round(2).to_s+'%' }
  end
  
  def print_churn_result
    puts ' '
    puts 'Customer churn result: '
    @result.each do |k, v|
      puts "  #{k.to_s.humanize}: #{v}"
    end
  end
  
  def load_sample_ml_result
    puts 'loading sample'
    file = File.read('db/churn_result.json')
    process_json(file)
  end

end
