class Customer < ApplicationRecord
  belongs_to :user
  
  # TODO: point from customer to twitter_personality
  has_one :twitter_personality
  has_many :transactions
  has_many :messages
  
  serialize :context, JSON
  
  def start_conversation
    # Send empty string to Watson Conversation
    Message.send_to_watson_conversation('', self) if messages.empty?
  end
  
  def name
    self.user.name
  end
  
  def twitter_id
    self.twitter_personality.username
  end
  
  def gender
    self.gender ? 'Male' : 'Female'
  end

end
