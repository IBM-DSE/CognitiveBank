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

  def expect_customer_dashboard
    expect(page).to have_text 'Cognitive Traveler Rewards Card'
  
    expect(page).to have_text 'Current Balance $ 1,265.87'
    expect(page).to have_text 'Available Credit $ 8,735.13'
    expect(page).to have_link 'View Balance Details'
  
    expect(page).to have_text 'Current Miles'
    expect(page).to have_text '57,892'
    expect(page).to have_link 'Rewards Center'
  
    expect(page).to have_text 'Last Statement Balance: $ 1,932.52'
    expect(page).to have_text 'Due on'
    today = Date.today
    mon = today.month + 1
    expect(page).to have_text Date.new(today.year + mon / 12, mon % 12, 1).strftime '%B %-d, %Y'
    expect(page).to have_link 'Make a Payment'
  
    expect(page).to have_text 'Transactions'
    expect(page).to have_text 'Date	Category Amount'
    expect(page).to have_text "#{today - 2}	Transportation"
    expect(page).to have_text "#{today - 9}	Transportation"
    expect(page).to have_text "#{today - 12}	Supermarkets"
    expect(page).to have_text "#{today - 14}	Hotel"
    expect(page).to have_text "#{today - 15}	Dining"
    expect(page).to have_text "#{today - 16}	Dining"
    expect(page).to have_text "#{today - 18}	Safari"
    expect(page).to have_text "#{today - 22}	Home"
    expect(page).to have_text "#{today - 23}	OfficeSupplies"
    expect(page).to have_text "#{today - 30}	Airfare"
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
