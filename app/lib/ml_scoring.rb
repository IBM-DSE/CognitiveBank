
# Handles ML Scoring
class MlScoring
  attr_reader :result
  
  def initialize(customer)
    # get score from MlScoringService
    @result = MlScoringService.get_result(customer) || default_score
    print_churn_result if @result
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
    Util.default_score
  end
end
