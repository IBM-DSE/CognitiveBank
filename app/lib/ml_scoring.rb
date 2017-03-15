class MlScoring
  
  attr_reader :result
  
  def initialize(customer)
    customer_attrs = customer.attributes.slice(*SCORING_ATTRS).values
    puts ' '
    puts 'Fetching churn probability from MLz churn model.'
    puts 'Sending customer attributes to churn scoring: '
    puts customer_attrs.to_s
    
    # post_to_scoring_ml
    score = MlScoringService.get_score(customer_attrs)

    process_score score
    
    print_churn_result
  end
  
  def to_h
    @result
  end
  
  def to_s
    @result.to_s
  end
  
  def update_token
    get_token
  end
  
  private
  
  SCORING_ATTRS = %w(age activity education sex state negtweets income)
  
  def process_score(score)
    puts score
    churn   = score['prediction'] == 1.0
    prob    = score['probability']['values'][score['prediction']]
    @result = { prediction: churn, probability: (prob*100.0).round(2).to_s+'%' }
  end
  
  def print_churn_result
    puts ' '
    puts 'Customer churn result: '
    @result.each do |k, v|
      puts "  #{k.to_s.humanize}: #{v}"
    end
  end
  
end
