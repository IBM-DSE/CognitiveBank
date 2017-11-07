
# Handles ML Scoring
class MlScoring
  attr_reader :result
  
  def initialize(customer)
    # get score from MlScoringService
    score = MlScoringService.get_score(customer) || default_score
    if score
      @result = MlScoringService.process_score(score)
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
  
  def print_churn_result
    puts 'Customer churn result: '
    @result.each do |k, v|
      puts "  #{k.to_s.humanize}: #{v}"
    end
    puts
  end
  
  def default_score
    Util.handle_score_error
  end
end
