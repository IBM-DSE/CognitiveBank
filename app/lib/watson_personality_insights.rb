class WatsonPersonalityInsights
  
  def initialize
    @personality = {}
    
    # load tweets from a specific user
    tweets       = Twitter.load_tweets
    
    # call WPI api with twitter data as input
    @jsonProfile  = call_wpi_api(tweets)
    
    # traverse WPI (json) output tree to extract results 
    traverse_json(@jsonProfile, 0)
    
    @personality = @personality.sort_by { |_key, value| value }.reverse.to_h
  end
  
  def to_h
    {
        personality: @personality,
        needs:       @needs.keys.first,
        values:      @values.keys.first
    }
  end
  
  def raw_json
    @jsonProfile
  end
  
  private
  
  # Watson Personality Insights URL and credentials
  WPI_URL      = 'https://gateway.watsonplatform.net/personality-insights/api/v2/profile'
  WPI_USERNAME = ENV['WPI_USERNAME']
  WPI_PASSWORD = ENV['WPI_PASSWORD']
  if ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_label('personality_insights')
    if convo_creds
      WPI_USERNAME = convo_creds['username']
      WPI_PASSWORD = convo_creds['password']
    end
  end
  
  # Watson Personality Insights Resource for making REST calls
  WPI_RESOURCE = RestClient::Resource.new WPI_URL, user: WPI_USERNAME, password: WPI_PASSWORD if WPI_USERNAME and WPI_PASSWORD
  
  def call_wpi_api(tweets)
    # call WPI with twitter data as input
    begin
      response = WPI_RESOURCE.post(tweets, { 'content-type': 'text/plain' })
      JSON.parse(response)
    rescue => e
      STDERR.puts "Watson Personality Insights ERROR: #{e}"
      Util.handle_wpi_error
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
          @needs = { data[0]['name'] => data[0]['percentage'] } 
        elsif data[0]['category'] == 'values'
          @values = { data[0]['name'] => data[0]['percentage'] } 
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
