require 'rails_helper'
require_relative 'shared_stuff'

feature 'Administrate Customers', include_shared: true do
  
  background do
    
    # Visit home page and click 'Log in'
    visit '/'
    expect_home_page
    
    # Log in as administrator
    login('admin@example.com', @admin_password)
    
    expect_admin_panel
  
  end
  
  scenario 'Create Two Sallys' do
    
    # Create first Sally
    create_sally
    
    # Expect her profile
    expect(page).to have_text 'sally@example.com'
    expect_sally_profile
    
    # Go back to admin
    click_link 'x_admin_link'
    expect_admin_panel
    
    # Create second Sally
    create_sally
    
    # Expect her profile with email sally1@example.com
    expect(page).to have_text 'sally1@example.com'
    expect_sally_profile
    
    click_link 'Account'
    click_link 'Log out'
    expect_home_page
    
    login('sally@example.com', 'password')
    
    # Expect the customer dashboard
    expect(page).to have_text 'Welcome back, Sally!'
    expect_customer_dashboard
  
  end
  
  scenario 'Create David With Custom Image' do
    
    click_link 'New Customer'
    expect_customer_form
    
    # Fill in required fields
    fill_in 'Name', with: 'David'
    fill_in 'Twitter Handle', with: 'dtom90'
    fill_in 'Age', with: '27'
    fill_in 'Activity', with: '3'
    select "Master's Degree", from: 'Education Level'
    select 'Male', from: 'Gender'
    fill_in 'State', with: 'NY'
    fill_in 'Negative Tweets', with: '0'
    fill_in 'Income', with: '2000'
    attach_file 'Custom Image:', Rails.root + 'spec/features/David.jpeg'
    
    click_button 'Create Customer'
    
    expect(page).to have_text "David's Profile:"
    expect(page).to have_css("img[src*='David.jpeg']")
    expect(page).to have_text 'david@example.com'
    
    expect(page).to have_text 'Gender: Male'
    expect(page).to have_text 'Age: 27'
    expect(page).to have_text 'State: NY'
    expect(page).to have_text 'Education Level: Masters degree'
    expect(page).to have_text '$ 2,000.00'
    expect(page).to have_text 'Investment:'
    expect(page).to have_text 'Annual Spending:'
    expect(page).to have_text 'Annual Transactions:'
    expect(page).to have_text 'Average Daily Transactions:'
    expect(page).to have_text 'Average Transaction Amount:'
    
    expect(page).to have_text 'Twitter Profile:'
    expect(page).to have_text '@dtom90'
    expect(page).to have_text 'Negative Finance-Related Tweets: 0'
    expect(page).to have_text 'Keywords'
    expect(page).to have_text 'Sentiment'
    expect(page).to have_text 'foreign exchange fees 0%'
    
    expect(page).to have_text 'Personality Insights:'
    expect(page).to have_text 'Needs:	Practicality'
    expect(page).to have_text 'Values: Self-transcendence'
  
  end

end


def expect_customer_form
  
  # Required fields
  expect(page).to have_text 'Name*: Twitter Handle*: Age*: Activity*:'
  expect(page).to have_text 'Education Level*:'
  expect(page).to have_select 'Education Level*:',
                              with_options: ['High School Degree', "Associate's Degree", "Bachelor's Degree", "Master's Degree", "Doctor's Degree"]
  expect(page).to have_select 'Gender*:', with_options: ['Male', 'Female']
  expect(page).to have_text 'State*: Negative Tweets*: Income*:'
  
  # Optional fields
  expect(page).to have_text 'Investment: Annual Spending: Annual Transactions:'
  expect(page).to have_text 'Average Daily Transactions: Average Transaction Amount:'
  expect(page).to have_select 'Nationality:', with_options: ['United States ($)', 'India (₹)']
  expect(page).to have_field 'Custom Image:'

end

def create_sally
  
  click_link 'New Customer'
  expect_customer_form
  
  # Fill in required fields
  fill_in 'Name', with: 'Sally'
  fill_in 'Twitter Handle', with: 'sally_may_22'
  fill_in 'Age', with: '22'
  fill_in 'Activity', with: '3'
  select "Doctor's Degree", from: 'Education Level'
  select 'Female', from: 'Gender'
  fill_in 'State', with: 'FL'
  fill_in 'Negative Tweets', with: '3'
  fill_in 'Income', with: '130500'
  
  click_button 'Create Customer'

end

def expect_sally_profile
  
  expect(page).to have_text "Sally's Profile:"
  expect(page).to have_text 'Gender: Female'
  expect(page).to have_text 'Age: 22'
  expect(page).to have_text 'State: FL'
  expect(page).to have_text 'Education Level: Doctorate'
  expect(page).to have_text 'Income: $ 130,500.00'
  expect(page).to have_text 'Investment:'
  expect(page).to have_text 'Annual Spending:'
  expect(page).to have_text 'Annual Transactions:'
  expect(page).to have_text 'Average Daily Transactions:'
  expect(page).to have_text 'Average Transaction Amount:'
  
  expect(page).to have_text 'Twitter Profile:'
  expect(page).to have_text '@sally_may_22'
  expect(page).to have_text 'Negative Finance-Related Tweets: 3'
  expect(page).to have_text 'Keywords'
  expect(page).to have_text 'Sentiment'
  expect(page).to have_text 'foreign exchange fees 0%'
  
  expect(page).to have_text 'Personality Insights:'
  expect(page).to have_text 'Needs:	Practicality'
  expect(page).to have_text 'Values: Self-transcendence'

end
