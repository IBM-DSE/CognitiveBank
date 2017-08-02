
# General Utilities
class Util
  def self.load_default_score
    puts 'loading sample'
    file = File.read('db/churn_result.json')
    JSON.parse(file)
  end

  def self.load_default_personality
    file = File.read('db/buce-personality.json')
    JSON.parse(file)
  end
end