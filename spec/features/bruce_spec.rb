require 'rails_helper'

feature 'Bruce', js: true do

  background do

    # Visit home page and click 'Log in'
    visit '/'
    expect(page).to have_text 'Cognitive Bank'
    expect(page).to have_text 'Log in'
    click_link 'Log in'

    # Fill in log in credentials
    within('h1') { expect(page).to have_text 'Log in' }
    within 'form' do
      expect(page).to have_text 'Email'
      expect(page).to have_text 'Password'
      fill_in 'Email', with: 'bruce@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
    end

    # Expect the customer dashboard
    expect(page).to have_text 'Welcome back, Bruce!'
    expect(page).to have_text 'Cognitive Traveler Rewards Card'
    expect(page).to have_text 'Current Balance'
    expect(page).to have_text 'Current Miles'
    expect(page).to have_text 'Last Statement Balance:'
    
  end
  
  scenario 'Bruce logs in and views his account' do
    
    # expect chatbot to pop up and start talking
    expect(page).to have_css '#chat-zone'
    within '#chat-window' do
      input = find_field('Send a message...')

      expect(page).to have_text "Hi there, I'm the Cognitive Bank Virtual Assistant! I can help you find a good offer. Interested?"

      input.native.send_keys('sure', :enter)

      expect(page).to have_text "Great! let's get started... What kind of offers are you interested in? (travel, restaurants, clothing)"

      input.native.send_keys('travel', :enter)

      expect(page).to have_text 'Looks like you enjoy adventurous trips! I see you were in Kenya last year. Are you interested in a safari again?'

      input.native.send_keys('yeah', :enter)

      expect(page).to have_text 'Great, which month are you planning?'

      input.native.send_keys('aPril', :enter)

      expect(page).to have_text 'Great, I have an offer that you might be interested in: 50% discount on 1-day Entrance Ticket to Corbett National Park in the foothills of the Himalayas'
      expect(page).to have_text 'Since you are traveling in April, can I make another offer?'

      input.native.send_keys('okay', :enter)

      expect(page).to have_text "Since you're going during the rainy season, I found a good offer for you: Marmot Minimalist Rain Jacket - Men's $139.73 $200.00 Save $60.27 (30%)"
      expect(page).to have_text 'Before you leave, we have something special just for you... In appreciation of your loyalty, we will waive your foreign transaction fees for this trip!'
    end
    
  end

  scenario "We visit Bruce's customer profile" do
    
    click_link 'Account'
    click_link 'Profile'

    expect(page).to have_text "Bruce's Profile:"
    
    expect(page).to have_text 'Customer Summary:'
    expect(page).to have_text 'Gender: Male'
    expect(page).to have_text 'Age: 41'
    expect(page).to have_text 'State: TX'
    expect(page).to have_text 'Education Level: Masters degree'
    expect(page).to have_text 'Income: $316,530.00'
    expect(page).to have_text 'Investment:'
    expect(page).to have_text 'Annual Spending:'
    expect(page).to have_text 'Annual Transactions:'
    expect(page).to have_text 'Average Daily Transactions:'
    expect(page).to have_text 'Average Transaction Amount:'

    expect(page).to have_text 'Twitter Profile:'
    expect(page).to have_text '@bruce_wayne64'
    expect(page).to have_text 'Negative Tweets:'
    expect(page).to have_text 'Keywords Sentiment'
    expect(page).to have_text 'foreign exchange fees 0%'

    within '#ml-churn' do
      expect(page).to have_text 'IBM Machine Learning Customer Churn Model:'
      expect(page).to have_text 'Prediction:'
      expect(page).to have_text 'Probability:'
      expect(page).to have_text 'Last Scoring Call:'
      visit current_path # refresh the page so that ML Scoring call completes
      within('#churn-prediction'){ expect(page).to have_text 'true' }
      within('#churn-probability'){ expect(page).to have_text '%' }
    end
    
    expect(page).to have_text 'Personality Insights:'
    expect(page).to have_text 'Agreeableness'
    expect(page).to have_text 'Conscientiousness'
    expect(page).to have_text 'Extraversion'
    expect(page).to have_text 'Openness'
    expect(page).to have_text 'Emotional range'
    expect(page).to have_text 'Values: Self-transcendence'
    
  end
  
end
