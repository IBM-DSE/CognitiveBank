RSpec.shared_context 'shared stuff', shared_context: :metadata do
  
  before {
    @admin_password = ENV['ADMIN_PASSWORD'] || 'password'
  }

  def expect_home_page
    expect(page).to have_text 'Cognitive Bank'
    expect(page).to have_text 'Log in'
  end
  
  def login(email, password)
    click_link 'Log in'
    within('h1') { expect(page).to have_text 'Log in' }
    within 'form' do
      expect(page).to have_text 'Email'
      expect(page).to have_text 'Password'
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Log in'
    end
  end

  def expect_admin_panel
    expect(page).to have_text 'Admin Panel'
    expect(page).to have_text 'Welcome, Admin!'
    expect(page).to have_text 'You are logged in as administrator'
  
    expect(page).to have_text 'Customers:'
    expect(page).to have_text 'Name Churn Prediction: Churn Probability: Scoring Time: Profile'
    expect(page).to have_text 'Bruce'
    expect(page).to have_text 'View Profile'
  
    expect(page).to have_text 'Machine Learning Services:'
    expect(page).to have_text 'Name Type Hostname Deployment Actions'
    expect(page).to have_link 'New Machine Learning Service'
  end
  
  subject do
    'this is the subject'
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'shared stuff', include_shared: true
end
