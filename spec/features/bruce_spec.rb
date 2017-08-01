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
      expect(page).to have_css "input[placeholder='Send a message...']"
      expect(page).to have_text "Hi there, I'm the Cognitive Bank Virtual Assistant! I can help you find a good offer. Interested?"
      page.fill_in 'Send a message...', with: 'sure'
      find('#chat-input').native.send_keys(:enter)
      # expect(page).to have_text "Great! let's get started... What kind of offers are you interested in? (travel, restaurants, clothing)"
      # page.fill_in 'Send a message...', with: 'travel'
      # find('#chat-input').native.send_keys(:enter)
      # expect(page).to have_text "Looks like you enjoy adventurous trips! I see you were in Kenya last year. Are you interested in a safari again?"
    end
  end
end
