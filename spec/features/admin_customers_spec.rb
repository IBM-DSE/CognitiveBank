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
    
    sally = {
      'Name'            => 'Sally',
      'Email'           => 'sally@example.com',
      'Twitter Handle'  => 'sally_may_22',
      'Age'             => '22',
      'Activity'        => '3',
      'Education Level' => 'Doctorate',
      'Gender'          => 'Female',
      'State'           => 'FL',
      'Negative Tweets' => '3',
      'Income'          => '130500'
    }
    
    # Create first Sally
    click_link 'New Customer'
    expect_customer_form
    fill_customer_form(sally)
    click_button 'Create Customer'
    
    # Expect Sally profile
    expect_customer_profile(sally)
    
    # Go back to admin
    click_link 'x_admin_link'
    expect_admin_panel
    
    # Create second Sally
    click_link 'New Customer'
    expect_customer_form
    fill_customer_form(sally)
    click_button 'Create Customer'
    
    # Expect Sally profile with email sally1@example.com
    sally['Email'] = 'sally1@example.com'
    expect_customer_profile(sally)
    
    # Log in as Sally
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
    
    david = {
      'Name'            => 'David',
      'Email'           => 'david@example.com',
      'Twitter Handle'  => 'dtom90',
      'Age'             => '27',
      'Activity'        => '3',
      'Education Level' => 'Masters degree',
      'Gender'          => 'Male',
      'State'           => 'NY',
      'Negative Tweets' => '0',
      'Income'          => '2000'
    }
    
    # Fill in form with David's profile and attach custom image
    fill_customer_form(david)
    attach_file 'Custom Image:', Rails.root + 'spec/features/David.jpeg'
    click_button 'Create Customer'
    
    # Expect David's customer profile and custom image
    expect_customer_profile(david)
    expect(page).to have_css("img[src*='David.jpeg']")
  
  end

end


def expect_customer_form
  
  # Required fields
  expect(page).to have_text 'Name*: Twitter Handle*: Age*: Activity*:'
  expect(page).to have_text 'Education Level*:'
  expect(page).to have_select 'Education Level*:', with_options: Customer.education_options
  expect(page).to have_select 'Gender*:', with_options: ['Male', 'Female']
  expect(page).to have_text 'State*: Negative Tweets*: Income*:'
  
  # Optional fields
  expect(page).to have_text 'Investment: Annual Spending: Annual Transactions:'
  expect(page).to have_text 'Average Daily Transactions: Average Transaction Amount:'
  expect(page).to have_select 'Nationality:', with_options: ['United States ($)', 'India (₹)']
  expect(page).to have_field 'Custom Image:'

end

def fill_customer_form(profile)
  
  # Fill in text fields
  p
  profile.except(*@non_text_fields).each_key do |field|
    fill_in field, with: profile[field]
  end
  
  # Select from dropdown fields
  profile.slice(*@select_fields).each_key do |field|
    select profile[field], from: field
  end

end
