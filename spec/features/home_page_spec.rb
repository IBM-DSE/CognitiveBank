require 'rails_helper'

RSpec.feature 'HomePage', type: :feature do
  scenario 'User visits home page' do
    visit '/'
    expect(page).to have_text 'Cognitive Bank'
  end
end
