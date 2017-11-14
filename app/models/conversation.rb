class Conversation
  
  # initialize conversation context with:
  # - customer currency
  # - churn prediction
  def self.initialize(customer)
    {
      cur: I18n.t('number.currency.format.unit', locale: customer.locale),
      will_churn: customer.will_churn?
    }.to_json.to_s
  end
  
  # class method for sending string message content and customer context to WC
  def self.send(customer, message, context)
    
    # construct payload from input message and context
    body = { input: { text: message }, context: context }.to_json
    
    begin
      
      # send the payload to Conversation service
      response = RestClient::Request.execute method:  :post, url: conversation_url, payload: body,
                                             headers: { content_type: :json, accept: :json },
                                             user:    USERNAME, password: PASSWORD
      
      # slice the output and context
      JSON.parse(response.body).deep_symbolize_keys!.slice(:output, :context)
    
    rescue => e
      STDERR.puts "Conversation ERROR: #{e}"
      STDERR.puts "Conversation Endpoint = #{CONVERSATION_RESOURCE}" if defined? CONVERSATION_RESOURCE
      STDERR.puts "Body sent to Watson Conversation: #{body}"
      STDERR.puts e.backtrace.select{ |l| l.start_with? Rails.root.to_s }[0]
      {output: { text: ["Oops! Looks like I haven't been configured correctly to speak with Watson."]}, context: {}}
    end
  end
  
  
  private
  
  API_ENDPOINT='https://gateway.watsonplatform.net/conversation/api/v1/workspaces/'
  VERSION     = '2016-09-20'
  
  USERNAME = ENV['CONVERSATION_USERNAME']
  PASSWORD = ENV['CONVERSATION_PASSWORD']
  if ENV['VCAP_SERVICES']
    convo_creds = CF::App::Credentials.find_by_service_label('conversation')
    if convo_creds
      USERNAME    = convo_creds['username']
      PASSWORD    = convo_creds['password']
    end
  end
  WORKSPACE_ID = ENV['WORKSPACE_ID']
  
  if USERNAME and PASSWORD and WORKSPACE_ID
    CONVERSATION_URL      = API_ENDPOINT + WORKSPACE_ID + '/message?version=' + VERSION if WORKSPACE_ID
    CONVERSATION_RESOURCE = RestClient::Resource.new CONVERSATION_URL, user: USERNAME, password: PASSWORD
  end
  
  def self.conversation_url
    API_ENDPOINT + ENV['WORKSPACE_ID'] + '/message?version=' + VERSION
  end

end
