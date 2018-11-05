RSpec.shared_context 'shared stuff', shared_context: :metadata do
  include CustomersHelper
  include ActionView::Helpers::NumberHelper
  
  before {
    @admin_password  = ENV['ADMIN_PASSWORD'] || 'password'
    @select_fields   = ['Education Level', 'Gender']
    @non_text_fields = @select_fields + ['Email']
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
    mon   = today.month
    expect(page).to have_text Date.new(today.year + mon / 12, mon % 12 + 1, 1).strftime '%B %-d, %Y'
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
  
  def expect_customer_profile(profile)
    
    expect(page).to have_text "#{profile['Name']}'s Profile:"
    expect(page).to have_text profile['Email']
    
    expect(page).to have_text "Gender: #{Customer.gender_mapping[profile['Gender']]}"
    
    Customer.standard_attributes.each do |attr|
      expect(page).to have_text "#{attr}: #{profile[attr]}"
    end
    
    Customer.currency_attributes.each do |attr|
      val = Nokogiri::HTML.parse(num_to_currency(profile[attr], locale: 'en')).text
      expect(page).to have_text "#{attr}: #{val}"
    end
    
    expect(page).to have_text "Twitter Profile: @#{profile['Twitter Handle']}"
    expect(page).to have_text 'Recent Tweets:'
    expect(page).to have_text "These foreign exchange fees are higher than Trump's wall #kenya #africa #borderwall #AmEx #bankrobbery"
    expect(page).to have_text "— #{profile['Name']} (@#{profile['Twitter Handle']}) #{(Date.today - 17).strftime('%B %-d, %Y')}"
    expect(page).to have_text "A stunning safari sunset in Mara Naboisho Conservancy#sunset #nofilter #africa #kenya #safari #maranaboisho"
    expect(page).to have_text "— #{profile['Name']} (@#{profile['Twitter Handle']}) #{(Date.today - 18).strftime('%B %-d, %Y')}"
    expect(page).to have_text "Traveling to Kenya DBX>NBO #kenya #outofafrica #emirates"
    expect(page).to have_text "— #{profile['Name']} (@#{profile['Twitter Handle']}) #{(Date.today - 20).strftime('%B %-d, %Y')}"
    
    expect(page).to have_text 'Top Keywords Sentiment'
    expect(page).to have_text 'foreign exchange fees 0%'
    expect(page).to have_text "Negative Finance-Related Tweets: #{profile['Negative Tweets']}"
    
    expect(page).to have_text 'Personality Insights:'
    expect(page).to have_text 'Needs:	Practicality'
    expect(page).to have_text 'Values: Self-transcendence'
    
    expect(page).to have_text 'IBM Machine Learning Prediction'
    
    expect(page).to have_text 'Customer Attributes:'
    
    expect(page).to have_text 'ML Scoring Service:'
    expect(page).to have_text 'Type:'
    expect(page).to have_text 'Name:'
    expect(page).to have_text 'Deployment ID:'
    
    expect(page).to have_text 'Customer Churn Prediction:'
    expect(page).to have_text 'Prediction:'
    expect(page).to have_text 'Probability:'
    expect(page).to have_text 'Scoring Time:'
  
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

end

RSpec.configure do |rspec|
  rspec.include_context 'shared stuff', include_shared: true
end
