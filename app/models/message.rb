class Message < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
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
    response = send_to_watson_conversation
    results  = eval(response.body)
    
    # update user context
    user.update_attribute :context, results[:context]
    
    # create watson messages
    results[:output][:text].each do |line|
      user.messages.create! content: line, watson_response: true
    end
  end
  
  private
  
  def send_to_watson_conversation
    CONVERSATION_RESOURCE.post({ input: { text: self.content }, context: user.context }.to_json,
                               :content_type => 'application/json')
  end
end
