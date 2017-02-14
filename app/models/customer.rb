class Customer < ApplicationRecord
  belongs_to :user
  
  # TODO: point from customer to twitter_personality
  has_one :twitter_personality
  has_many :transactions
  has_many :messages
  
  serialize :context, JSON

  attr_reader :churn_result
  
  def start_conversation
    Message.send_to_watson_conversation('', self) if messages.empty?  # Send empty string to Watson Conversation
  end
  
  def clear_conversation
    messages.destroy_all
    self.context = nil
    self.save
  end
  
  def get_churn
    @churn_result = ML_Scoring.new self
    @churn_result
  end
  
  def name
    self.user.name
  end
  
  def twitter_id
    self.twitter_personality.username
  end
  
  def gender
    self.sex == 'M' ? 'Male' : 'Female'
  end

end
