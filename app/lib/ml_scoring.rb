class ML_Scoring
  
  ML_SCORING_RESOURCE = RestClient::Resource.new ENV['ML_SCORING_URL'], :read_timeout => ENV['ML_SCORING_TIMEOUT'] || 2
  
  def initialize(customer)
    @customer_attrs = customer.attributes.slice(*SCORING_ATTRS).values
    puts ' '
    puts 'Fetching churn probability from MLz churn model.'
    puts 'Sending customer attributes to churn scoring: '
    puts @customer_attrs.to_s
    post_to_scoring_ml ML_SCORING_RESOURCE
    print_churn_result
  end
  
  def will_churn?
    @result[:churn]
  end
  
  def probability
    @result.probability
  end
  
  private
  
  # SCORING_ATTRS = %w(sex age education investment income activity yrly_amt avg_daily_tx yrly_tx avg_tx_amt negtweets)
  
  SCORING_ATTRS = %w(age activity education sex state negtweets income)
  
  def post_to_scoring_ml(ml_resource)
    puts 'Posting to endpoint '+ml_resource.url
    headers = { :content_type => 'application/json', :Authorization => ENV['ML_SCORING_AUTH'] }
    body    = { 'Record': @customer_attrs }.to_json
    begin
      puts headers
      puts body
      request = ml_resource.post(body, headers)
      # POST request with modified headers
      # RestClient.post 'http://example.com/resource', {:foo => 'bar', :baz => 'qux'}, {:Authorization => 'Bearer cT0febFoD5lxAlNAXHo6g'}
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
    @result = { churn: churn, probability: (prob*100.0).round(2).to_s+'%' }
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