
class Conversation
  
  API_ENDPOINT='https://gateway.watsonplatform.net/conversation/api/v1/workspaces/'
  VERSION     = '2016-09-20'
  
  if ENV['CONVERSATION_USERNAME'] and ENV['CONVERSATION_PASSWORD']
    USERNAME = ENV['CONVERSATION_USERNAME']
    PASSWORD = ENV['CONVERSATION_PASSWORD']
  elsif ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_label('conversation')
    USERNAME    = convo_creds['username']
    PASSWORD    = convo_creds['password']
  end
  WORKSPACE_ID = ENV['WORKSPACE_ID']
  
  URL                   = API_ENDPOINT + WORKSPACE_ID + '/message?version=' + VERSION
  CONVERSATION_RESOURCE = RestClient::Resource.new URL, USERNAME, PASSWORD
  
  # class method for sending string message content and customer context to WC
  def self.send(message, context)
    
    body = { input: { text: message }, context: context }.to_json
    begin
      response = CONVERSATION_RESOURCE.post(body, :content_type => 'application/json')
      eval(response.body).slice(:output, :context)
    rescue Exception => ex
      puts "ERROR: #{ex.response}"
      puts "Conversation Endpoint = #{CONVERSATION_RESOURCE}"
      puts "Body sent to Watson Conversation: #{body}"
      raise ex
    end
  end
  
end