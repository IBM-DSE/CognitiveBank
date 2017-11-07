require 'rails_helper'

feature 'Admin' do

  scenario 'Manage Admin Panel' do

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
      fill_in 'Email', with: 'david@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
    end

    expect_admin_panel
    
    # Create new machine learning service
    click_link 'New Machine Learning Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Name: Hostname: Username: Password: Deployment:'
    expect(page).to have_text 'MLZ Settings Ldap port: Scoring hostname: Scoring port:'
    expect(page).to have_button 'Create Machine Learning Scoring Service'

    # Fill in new Machine Learning Service with bad hostname and timeout
    fill_in 'Hostname:', with: 'not!a-reeal-howssstname'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Hostname: Failed to open TCP connection to not!a-reeal-howssstname:443 (getaddrinfo: nodename nor servname provided, or not known)'
    expect(page).to have_text "Username: can't be blank Password: can't be blank Deployment: can't be blank"

    # Fill in new Machine Learning Service with good hostname but not ML service
    fill_in 'Hostname:', with: 'www.ibm.com'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Hostname: HTTPNotFound'
    expect(page).to have_text "Username: can't be blank Password: can't be blank Deployment: can't be blank"
    
    # Fill in new Machine Learning Service with WML and bad credentials
    fill_in 'Name:', with: 'test'
    fill_in 'Hostname:', with: 'ibm-watson-ml.mybluemix.net'
    fill_in 'Username:', with: 'test'
    fill_in 'Password:', with: 'test'
    fill_in 'Deployment:', with: 'test'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Authorization Failure Against ibm-watson-ml.mybluemix.net'
    expect(page).to have_text 'Username: HTTPUnauthorized Password: HTTPUnauthorized'
    
  end
  
end

def expect_admin_panel
  expect(page).to have_text 'Admin Panel'
  expect(page).to have_text 'Welcome, David Thomason!'
  expect(page).to have_text 'You are logged in as administrator'

  expect(page).to have_text 'Customers:'
  expect(page).to have_text 'Name Churn Prediction: Churn Probability: Last Scoring Call: Profile'
  expect(page).to have_text 'Bruce View Profile'

  expect(page).to have_text 'Machine Learning Services:'
  expect(page).to have_text 'Id Name Hostname Deployment Authentication ML Scoring Actions'
  expect(page).to have_link 'New Machine Learning Service'
end

def expect_new_ml_service_page
  expect(page).to_not have_link 'New Machine Learning Service'
  expect(page).to have_text 'New Machine Learning Service'
end