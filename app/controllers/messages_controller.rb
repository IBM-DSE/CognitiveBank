class MessagesController < ApplicationController
  before_action :logged_in_user

  # Start conversation with Watson
  def start
    
    if current_customer.messages.empty? # if there are no messages with this customer yet
  
      # Send empty string to Watson Conversation
      Message.send_to_watson_conversation('', current_customer)
      
    end
    
  end
  
  def create
    context = JSON.parse(message_params[:context].presence || '{}') # set the context variable as a Hash
    
    response = Conversation.send message_params[:content], context  # send message and context to Watson Conversation
    
    @messages = response[:output][:text]
    @context = response[:context].to_json
    
    respond_to { |format| format.js } # respond with Javascript to update chat bubble
  end

  private

  def message_params
    params.require(:message).permit(:content, :context)
  end
end
