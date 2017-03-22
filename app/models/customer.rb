class Customer < ApplicationRecord
  belongs_to :user
  
  # TODO: point from customer to twitter_personality
  has_one :twitter_personality
  has_many :transactions
  has_many :messages
  
  serialize :context, JSON
  
  
  def get_personality
    personality = WatsonPersonalityInsights.new
    personality.to_h
  end
  
  def update_churn
    churn = MlScoring.new self
    if churn.result
      pp churn.result
      self.update! churn.result
      pp self.inspect
    end
  end
  
  def will_churn?
    update_churn
    self.churn_prediction
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
  
  def reset
    clear_conversation
    clear_prediction
  end
  
  private

  def start_conversation
    Message.send_to_watson_conversation('', self) if messages.empty?  # Send empty string to Watson Conversation
  end

  def clear_conversation
    messages.destroy_all
    self.context = nil
    self.save
  end
  
  def clear_prediction
    self.churn_prediction = nil
    self.churn_probability = nil
    self.save!
  end
  
end
