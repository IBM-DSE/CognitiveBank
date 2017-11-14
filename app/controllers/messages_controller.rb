class MessagesController < ApplicationController
  before_action :logged_in_user

  # Send message to Watson
  def create
  
    # set the context variable as a Hash
    context = JSON.parse(message_params[:context].presence || Conversation.initialize(current_customer))

    # send message and context to Watson Conversation
    response = Conversation.send current_customer, message_params[:content], context
    
    # Extract messages and context 
    @messages = response[:output][:text]
    @context = response[:context].to_json
    
    respond_to { |format| format.js } # respond with Javascript to update chat bubble
  end

  private

  def message_params
    params.require(:message).permit(:content, :context)
  end
end
