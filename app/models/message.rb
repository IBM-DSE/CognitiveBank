class Message < ApplicationRecord
  belongs_to :customer
  validates :customer_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  API_ENDPOINT='https://gateway.watsonplatform.net/conversation/api/v1/workspaces/'
  VERSION     = '2016-09-20'
  
  
  if ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_name('CognitiveBank-Conversation')
    USERNAME    = convo_creds['username']
    PASSWORD    = convo_creds['password']
  else
    USERNAME = ENV['CONVERSATION_USERNAME']
    PASSWORD = ENV['CONVERSATION_PASSWORD']
  end
  WORKSPACE_ID = ENV['WORKSPACE_ID']
  
  URL                   = API_ENDPOINT + WORKSPACE_ID + '/message?version=' + VERSION
  CONVERSATION_RESOURCE = RestClient::Resource.new URL, USERNAME, PASSWORD
  
  def send_to_watson
    
    # send to watson conversation
    response           = send_to_watson_conversation
    results            = eval(response.body)
    
    # update user context
    customer[:context] = results[:context]
    
    # create watson messages
    results[:output][:text].each do |line|
      customer.messages.build content: line, watson_response: true
    end
    
    customer.save
  end
  
  private
  
  def send_to_watson_conversation
    body = { input: { text: self.content }, context: customer.context }.to_json
    begin
      CONVERSATION_RESOURCE.post(body, :content_type => 'application/json')
    rescue Exception => ex
      puts "ERROR: #{ex.response}"
      puts "Conversation Endpoint = #{CONVERSATION_RESOURCE}"
      puts "Body sent to Watson Conversation: #{body}"
      raise ex
    end
  end
end
