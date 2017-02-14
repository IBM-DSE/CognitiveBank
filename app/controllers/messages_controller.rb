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
    
    # Build new message from this user
    @message = current_customer.messages.build(message_params)
    
    if @message.send_to_watson # if message send was successful,
      respond_to { |format| format.js } # respond with Javascript to update chat bubble
    else
      flash.now[:danger] = 'Sorry, there was a problem when talking to Watson. Ask an administrator for assistance.'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :context)
  end
end
