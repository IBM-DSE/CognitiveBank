require 'csv'

class Customer < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one :twitter_personality, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :messages
  belongs_to :ml_scoring_service, optional: true
  
  serialize :context, JSON
  serialize :score, JSON
  
  def self.required_attributes
    [:name, :twitter_id] + MlScoringService.scoring_attrs
  end
  
  required_attributes.each do |req_attr|
    validates req_attr, presence: true
  end
  
  after_initialize :defaults
  before_create :load_customer_data
  
  def self.optional_attributes
    [:investment, :yrly_amt, :yrly_tx, :avg_daily_tx, :avg_tx_amt, :locale]
  end
  
  def self.form_attributes
    required_attributes + optional_attributes
  end
  
  def self.gender_options
    {
      'Male': 'M',
      'Female': 'F'
    }.to_a
  end
  
  def self.education_options
    {
      'High School Degree': 'High school graduate',
      "Associate's Degree": 'Associate degree',
      "Bachelor's Degree":  'Bachelors degree',
      "Master's Degree":    'Masters degree',
      "Doctor's Degree":    'Doctorate'
    }.to_a
  end

  def self.locale_options
    {
      'United States ($)': 'en',
      'India (₹)': 'en-IN'
    }.to_a
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
  
  def will_churn?
    churn = MlScoring.new self
    update! churn.result if churn.result
    churn_prediction
  end
  
  def user
    super || build_user
  end
  
  def email
    user.email
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
  
  def defaults
    unless persisted?
      self.user   ||= User.new
      self.locale ||= 'en'
    end
  end
  
  def load_customer_data
    puts 'Loading Twitter personality...'
    personality              = CSV.table('data/bruce_twitter.csv')[0].to_h.except(:username, :category)
    self.twitter_personality ||= TwitterPersonality.new personality
    
    puts 'Loading Transactions...'
    CSV.foreach('data/bruce_transactions.csv', headers: true) do |row|
      # add the transaction
      transactions.build(customer_id: row['CUSTID'],
                         date:        Date.strptime(row['DATE'], '%m/%d/%Y'),
                         category:    row['CATEGORY'])
    end
    self.img = Customer.where(gender: gender).count + 1
  end
  
  def clear_conversation
    self.context = nil
    self.save
  end
  
  def clear_prediction
    self.churn_prediction      = nil
    self.churn_probability     = nil
    self.ml_scoring_service_id = nil
    self.save
  end

end
