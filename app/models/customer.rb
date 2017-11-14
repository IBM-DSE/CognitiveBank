require 'csv'

class Customer < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one :twitter_personality, dependent: :destroy
  has_many :transactions
  has_many :messages
  belongs_to :ml_scoring_service, optional: true
  
  serialize :context, JSON

  before_save :default_values
  def default_values
    puts 'Loading Twitter personality...'
    personality = CSV.table('db/bruce_twitter.csv')[0].to_h.except(:category)
    self.twitter_personality = TwitterPersonality.new personality
  end
  
  def self.editable_attributes
    MlScoringService.scoring_attrs
    # [:gender, :age, :state, :education, :income, :investment, :yrly_amt, :yrly_tx,:avg_daily_tx, :avg_tx_amt]
  end
  
  def get_personality(tweets)
    puts ' '
    puts "Fetching Personality Insights from #{name}'s tweets..."
    WatsonPersonalityInsights.new(tweets)
  end
  
  def extract_signals(tweets)
    puts ' '
    puts "Fetching Signals from #{name}'s tweets..."
    NaturalLanguageUnderstanding.extract_keywords(tweets)
  end
  
  def update_churn
    churn = MlScoring.new self
    update! churn.result if churn.result
  end
  
  def will_churn?
    update_churn
    churn_prediction
  end
  
  def name
    user.name
  end
  
  def twitter_id
    twitter_personality.username
  end
  
  def display_gender
    gender == 'M' ? 'Male' : 'Female'
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
    self.ml_scoring_service_id = nil
    self.save!
  end
  
end
