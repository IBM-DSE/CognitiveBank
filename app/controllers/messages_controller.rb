class MessagesController < ApplicationController
  before_action :logged_in_user
  
  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      respond_to do |format|
        format.js
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      @feed_items = []
      render 'static_pages/home'
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
