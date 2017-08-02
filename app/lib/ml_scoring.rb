
# Handles ML Scoring
class MlScoring
  attr_reader :result
  
  def initialize(customer)
    # get score from MlScoringService
    score = MlScoringService.get_score(customer) || default_score
    if score
      process_score score
      print_churn_result
    end
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
  
  def default_score
    Util.load_default
  end
end
