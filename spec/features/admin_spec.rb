require 'rails_helper'

feature 'Admin' do
  
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
    
  end

  scenario 'Bad Machine Learning Service Displays Form Errors' do

    # Click create without any fields, show can't be blank
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text "Hostname: can't be blank Username: can't be blank Password: can't be blank Deployment: can't be blank"
    
    # Fill in new Machine Learning Service with bad hostname and timeout
    fill_in 'Hostname:', with: 'not!a-reeal-howssstname'
    fill_in 'Username:', with: 'test'
    fill_in 'Password:', with: 'test'
    fill_in 'Deployment:', with: 'test'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Hostname: Failed to open TCP connection to not!a-reeal-howssstname:443 (getaddrinfo: nodename nor servname provided, or not known)'

    # Fill in new Machine Learning Service with good hostname but not ML service
    fill_in 'Hostname:', with: 'www.ibm.com'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Hostname: HTTPNotFound'
    
    # Fill in new Machine Learning Service with WML and bad credentials
    fill_in 'Hostname:', with: 'ibm-watson-ml.mybluemix.net'
    click_button 'Create Machine Learning Scoring Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Authorization Failure Against ibm-watson-ml.mybluemix.net'
    expect(page).to have_text 'Username: HTTPUnauthorized Password: HTTPUnauthorized'
    
  end

  scenario 'Good Machine Learning Service Succeeds' do

    if ENV['ML_HOSTNAME'] and ENV['ML_USERNAME'] and ENV['ML_PASSWORD'] and ENV['ML_DEPLOYMENT']
      fill_in 'Name:', with: 'test'
      fill_in 'Hostname:', with: ENV['ML_HOSTNAME']
      fill_in 'Username:', with: ENV['ML_USERNAME']
      fill_in 'Password:', with: ENV['ML_PASSWORD']
      fill_in 'Deployment:', with: ENV['ML_DEPLOYMENT']
      click_button 'Create Machine Learning Scoring Service'
      expect_admin_panel
      expect(page).to have_text "test #{ENV['ML_HOSTNAME']} #{ENV['ML_DEPLOYMENT']} Successful Successful"
      expect(page).to have_link 'edit'
      expect(page).to have_button 'delete'
    end
    
  end

  scenario 'Detect Bluemix Machine Learning Service Succeeds' do

    if ENV['VCAP_SERVICES']
      
      click_link 'Detect Bluemix WML Service'

      expect(page).to have_field('Name:', with: 'Churning Model (Deployed)')
      expect(page).to have_field('Hostname:', with: ENV['ML_HOSTNAME'])
      expect(page).to have_field('Username:', with: ENV['ML_USERNAME'])
      expect(page).to have_field('Password:', with: ENV['ML_PASSWORD'])
      expect(page).to have_field('Deployment:', with: ENV['ML_DEPLOYMENT'])

      click_button 'Create Machine Learning Scoring Service'
      expect_admin_panel
      expect(page).to have_text "Churning Model (Deployed) #{ENV['ML_HOSTNAME']} #{ENV['ML_DEPLOYMENT']} Successful Successful"
      expect(page).to have_link 'edit'
      expect(page).to have_button 'delete'
      
    end
    
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
  expect(page).to have_link 'Detect Bluemix WML Service'
end