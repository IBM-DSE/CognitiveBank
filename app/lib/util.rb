
# General Utilities
class Util
  def self.load_default
    puts 'loading sample'
    file = File.read('db/churn_result.json')
    JSON.parse(file)
  end
end