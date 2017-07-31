require 'rails_helper'

RSpec.feature 'HomePage', type: :feature do
  scenario 'User creates a new widget' do
    visit '/'
    expect(page).to have_text 'Cognitive Bank'
  end
end
