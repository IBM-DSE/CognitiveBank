
# General Utilities
class Util
  def self.default_score
    file = File.read('db/churn_result.json')
    MlScoringService.process_score_mlz(JSON.parse(file))
  end

  def self.handle_wpi_error
    file = File.read('db/buce-personality.json')
    JSON.parse(file)
  end
  
  def self.handle_nlu_error
    file = File.read('db/bruce_tweet_keywords.json')
    JSON.parse(file)
  end
end