require 'rails_helper'

RSpec.feature 'Bruce', type: :feature do
  scenario 'Bruce logs in a views his account' do
    visit '/'
    expect(page).to have_text 'Cognitive Bank'
    expect(page).to have_text 'Log in'
    click_link 'Log in'

    expect(page).to have_text 'Email'
    expect(page).to have_text 'Password'
    fill_in 'Email', with: 'bruce@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_text 'Welcome back, Bruce!'
    expect(page).to have_text 'Cognitive Traveler Rewards Card'
    expect(page).to have_text 'Current Balance'
    expect(page).to have_text 'Current Miles'
    expect(page).to have_text 'Last Statement Balance:'

  end
end
