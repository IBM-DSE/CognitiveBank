class Message < ApplicationRecord
  belongs_to :customer
  validates :customer_id, presence: true
  validates :content, presence: true#, length: { maximum: 140 }
  
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

  # send self to watson conversation
  def send_to_watson
    Message.send_to_watson_conversation content, customer
  end
  
  # class method for sending string message content and customer context to WC
  def self.send_to_watson_conversation(content, customer)
    
    body = { input: { text: content }, context: customer.context }.to_json
    begin
      response = CONVERSATION_RESOURCE.post(body, :content_type => 'application/json')
      Message.update_customer eval(response.body), customer
    rescue Exception => ex
      puts "ERROR: #{ex.response}"
      puts "Conversation Endpoint = #{CONVERSATION_RESOURCE}"
      puts "Body sent to Watson Conversation: #{body}"
      raise ex
    end
  end
  
  private
  
  def self.update_customer(results, customer)
    # update user context
    customer.context = results[:context]
    puts customer.context
    
    # create watson messages
    results[:output][:text].each do |line|
      msg = customer.messages.build content: line, watson_response: true
      puts msg.content
    end
    
    # save the customer data
    customer.save
  rescue Exception => e
    puts e
  end

end
