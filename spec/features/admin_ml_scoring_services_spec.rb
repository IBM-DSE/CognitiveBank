require 'rails_helper'
require_relative 'shared_stuff'

feature 'Administrate MlScoringServices', include_shared: true do
  
  background do
    
    # Visit home page
    visit '/'
    expect_home_page
    
    # Log in as administrator
    login('admin@example.com', @admin_password)
    
    expect_admin_panel
    
    # Create new machine learning service
    click_link 'New Machine Learning Service'
    expect_new_ml_service_page
    expect(page).to have_text 'Name: Hostname: Username: Password: Deployment:'
    expect(page).to have_text 'MLZ Settings LDAP port: Scoring port: Scoring hostname:'
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
    expect(page).to have_text 'Hostname: Failed to open TCP connection to not!a-reeal-howssstname:443'
    
    # Fill in new Machine Learning Service with good hostname but not ML service
    # fill_in 'Hostname:', with: 'www.ibm.com'
    # click_button 'Create Machine Learning Scoring Service'
    # expect_new_ml_service_page
    # expect(page).to have_text 'Hostname: HTTPNotFound'
    
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
      
      vcap     = JSON.parse(ENV['VCAP_SERVICES'])
      creds    = vcap['pm-20'][0]['credentials']
      hostname = creds['url'].split('//')[1]
      
      click_link 'Detect Bluemix WML Service'
      
      expect(page).to have_field('Hostname:', with: hostname)
      expect(page).to have_field('Username:', with: creds['username'])
      expect(page).to have_field('Password:', with: creds['password'])
      deployment = find_field('Deployment')['value']
      
      click_button 'Create Machine Learning Scoring Service'
      expect_admin_panel
      expect(page).to have_text "Watson Machine Learning (Cloud) #{hostname} #{deployment}"
      expect(page).to have_link 'Edit'
      expect(page).to have_button 'Delete'
    
    end
  
  end

end

def expect_new_ml_service_page
  expect(page).to_not have_link 'New Machine Learning Service'
  expect(page).to have_text 'New Machine Learning Service'
  expect(page).to have_link 'Detect Bluemix WML Service'
end