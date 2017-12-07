require 'rails_helper'

feature 'Bruce', js: true, include_shared: true do
  
  background do
    # Visit home page and click 'Log in'
    visit '/'
    expect_home_page
    
    login('bruce@example.com', 'password')
    
    # Expect the customer dashboard
    expect(page).to have_text 'Welcome back, Bruce!'
    expect_customer_dashboard
  end
  
  scenario 'Bruce logs in and views his account' do
    
    # Expect chatbot to pop up and start talking
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
    
    # Expect Bruce's profile
    expect_customer_profile(
      'Name'                       => 'Bruce',
      'Email'                      => 'bruce@example.com',
      'Twitter Handle'             => 'bruce_wayne64',
      'Gender'                     => 'Male',
      'Age'                        => '41',
      'State'                      => 'TX',
      'Negative Tweets'            => '13',
      'Education Level'            => "Master's Degree",
      'Income'                     => '316530',
      'Investment'                 => '108972',
      'Annual Spending'            => '70662.63',
      'Annual Transactions'        => '362',
      'Average Daily Transactions' => '0.99',
      'Average Transaction Amount' => '195.20'
    )

    # Refresh the page so that ML Scoring call completes
    visit current_path
    
    # Expect a churn prediction
    within '#ml-churn' do
      expect(page).to have_text 'Will Churn'
      expect(page).to have_text '%'
    end
    
  end

end
