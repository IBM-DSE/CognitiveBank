require 'csv'

class Customer < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one :twitter_personality, dependent: :destroy
  has_many :transactions
  has_many :messages
  belongs_to :ml_scoring_service, optional: true
  
  serialize :context, JSON

  def self.required_attributes
    [:name, :twitter_id] + MlScoringService.scoring_attrs
  end
  
  required_attributes.each do |req_attr|
    validates req_attr, presence: true
  end

  after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new

  def set_defaults
    self.user ||= User.new
    self.twitter_personality ||= TwitterPersonality.new
  end
  
  before_save :default_values
  def default_values
    puts 'Loading Twitter personality...'
    personality = CSV.table('db/bruce_twitter.csv')[0].to_h.except(:username, :category)
    twitter_personality.update personality
    self.locale ||= 'en'
  end

  def self.optional_attributes
    [:investment, :yrly_amt, :yrly_tx,:avg_daily_tx, :avg_tx_amt, :locale]
  end
  
  def self.form_attributes
    required_attributes + optional_attributes
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

  def user
    super || build_user
  end
  
  def name
    user.name
  end

  def name=(name)
    user.name = name
  end

  def twitter_personality
    super || build_twitter_personality
  end
  
  def twitter_id
    twitter_personality.username
  end

  def twitter_id=(handle)
    twitter_personality.username = handle
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
