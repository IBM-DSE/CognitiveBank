class Message < ApplicationRecord
  belongs_to :customer
  validates :customer_id, presence: true
  validates :content, presence: true#, length: { maximum: 140 }
  
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

  # send self to watson conversation
  def send_to_watson
    puts ' '
    puts "#{customer.name} says: \"#{content}\""
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

    # print intents and entities
    if results[:intents][0] and results[:intents][0][:confidence] > 0.9 or results[:entities][0]
      puts ' '
      puts 'Watson NLP results:'
    end
    if results[:intents][0] and results[:intents][0][:confidence] > 0.9
      puts "Intent: #{results[:intents][0][:intent].upcase}"
    end
    if results[:entities][0]
      range = results[:entities][0][:location]
      puts "Entities: #{results[:input][:text][range[0]..range[1]].upcase}"
    end

    # store watson messages
    results[:output][:text].each do |line|
      msg = customer.messages.build content: line, watson_response: true
      puts ' '
      puts "Watson response: \"#{msg.content}\""
    end
    
    # save the customer data
    customer.save
    
    if results[:output][:action]
      action = results[:output][:action]
      puts ' '
      puts 'Watson Conversation Action Signal: '+action
      
      if action == 'check_churn'
        send_to_watson_conversation('churn', customer) if customer.will_churn?
      end
    end
    
  rescue Exception => e
    puts e
  end

end
