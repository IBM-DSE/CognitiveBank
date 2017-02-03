class MessagesController < ApplicationController
  before_action :logged_in_user
  
  def create
    
    # Build new message from this user
    @message = current_customer.messages.build(message_params)
    
    # Send to Watson Conversation
    if @message.send_to_watson
      
      # Respond with Javascript to update chat bubble
      respond_to { |format| format.js }
    else
      flash.now[:danger] = 'Sorry, there was a problem when talking to Watson. Ask an administrator for assistance.'
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters
  # is just a good pattern since you'll be able to reuse the same
  # permit list between create and update. Also, you can specialize
  # this method with per-user checking of permissible attributes.
  def message_params
    params.require(:message).permit(:content)
  end
end
