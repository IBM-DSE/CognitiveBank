class WatsonPersonalityInsights
  
  def initialize
    @personality = {}
    
    # load tweets from a specific user
    tweets       = load_tweets('db/Bruce_tweets.txt')
    
    # call WPI api with twitter data as input
    jsonProfile  = call_wpi_api(tweets)
    
    # traverse WPI (json) output tree to extract results 
    traverse_json(jsonProfile, 0)
    
    @personality = @personality.sort_by { |_key, value| value }.reverse.to_h
  end
  
  def to_h
    {
        personality: @personality,
        needs:       @needs,
        values:      @values
    }
  end
  
  private
  
  # Watson Personality Insights URL and credentials
  URL          = 'https://gateway.watsonplatform.net/personality-insights/api/v2/profile'
  if ENV['WPI_USERNAME'] and ENV['WPI_PASSWORD']
    USERNAME = ENV['WPI_USERNAME']
    PASSWORD = ENV['WPI_PASSWORD']
  elsif ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_label('personality_insights')
    USERNAME    = convo_creds['username']
    PASSWORD    = convo_creds['password']
  end
  
  # Watson Personality Insights Resource for making REST calls
  WPI_RESOURCE = RestClient::Resource.new URL, user: USERNAME, password: PASSWORD
  
  def load_tweets(filename)
    # load tweets from file
    File.open(filename, 'r').read
  end
  
  def call_wpi_api(tweets)
    # call WPI with twitter data as input
    begin
      response = WPI_RESOURCE.post(tweets, { 'content-type': 'text/plain' })
      JSON.parse(response)
    rescue => e
      STDERR.puts "Watson Personality Insights ERROR: #{e}"
      Util.load_default_personality
    end
  end
  
  def traverse_json(data, level)
    
    case level
      
      when 0
        traverse_json(data['tree'], level+1)
      when 1
        traverse_json(data['children'], level+1)
      when 2
        traverse_json(data[0]['children'], level+1)
        traverse_json(data[1]['children'], level+1)
        traverse_json(data[2]['children'], level+1)
      when 3
        if data[0]['category'] == 'personality'
          traverse_json(data[0]['children'], level+1)
        elsif data[0]['category'] == 'needs'
          @needs = data[0]['name']
#       @needs['percentage'] = data[0]['percentage'] 
        elsif data[0]['category'] == 'values'
          @values = data[0]['name']
#       @values['percentage'] = data[0]['percentage'] 
          return
        end
      
      when 4
        (0..4).each do |i|
          @personality[data[i]['name']] = data[i]['percentage']
        end
        return
    
    end
  
  end

end
