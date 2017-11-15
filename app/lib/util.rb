
# General Utilities
class Util
  def self.default_score
    file = File.read('data/churn_result.json')
    MlScoringService.analyze_score(JSON.parse(file))
  end

  def self.handle_wpi_error
    file = File.read('data/buce-personality.json')
    JSON.parse(file)
  end
  
  def self.handle_nlu_error
    file = File.read('data/bruce_tweet_keywords.json')
    JSON.parse(file)
  end
end