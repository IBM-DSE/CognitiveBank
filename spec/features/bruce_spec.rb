require 'rails_helper'

RSpec.feature 'Bruce', type: :feature, js: true do
  scenario 'Bruce logs in and views his account' do
    visit '/'
    expect(page).to have_text 'Cognitive Bank'
    expect(page).to have_text 'Log in'
    click_link 'Log in'

    within('h1') { expect(page).to have_text 'Log in' }
    within 'form' do
      expect(page).to have_text 'Email'
      expect(page).to have_text 'Password'
      fill_in 'Email', with: 'bruce@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
    end

    expect(page).to have_text 'Welcome back, Bruce!'
    expect(page).to have_text 'Cognitive Traveler Rewards Card'
    expect(page).to have_text 'Current Balance'
    expect(page).to have_text 'Current Miles'
    expect(page).to have_text 'Last Statement Balance:'

    # expect chatbot to pop up and start talking
    expect(page).to have_css '#chat-zone'
    within '#chat-window' do
      input = find_field('Send a message...')

      expect(page).to have_text "Hi there, I'm the Cognitive Bank Virtual Assistant! I can help you find a good offer. Interested?"

      input.native.send_keys('sure', :enter)

      expect(page).to have_text "Great! let's get started... What kind of offers are you interested in? (travel, restaurants, clothing)"

      input.native.send_keys('travel', :enter)

      expect(page).to have_text "Looks like you enjoy adventurous trips! I see you were in Kenya last year. Are you interested in a safari again?"

      input.native.send_keys('yeah', :enter)

      expect(page).to have_text "Great, which month are you planning?"

      input.native.send_keys('April', :enter)

      expect(page).to have_text "Great, I have an offer that you might be interested in: 50% discount on 1-day Entrance Ticket to Corbett National Park in the foothills of the Himalayas"
      expect(page).to have_text "Since you are traveling in April, can I make another offer?"

      input.native.send_keys('okay', :enter)

      expect(page).to have_text "Since you're going during the rainy season, I found a good offer for you: Marmot Minimalist Rain Jacket - Men's $139.73 $200.00 Save $60.27 (30%)"
      expect(page).to have_text "Before you leave, we have something special just for you... In appreciation of your loyalty, we will waive your foreign transaction fees for this trip!"
    end
  end
end
