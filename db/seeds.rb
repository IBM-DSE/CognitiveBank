require 'csv'


puts 'Loading the customers and transactions...'
csv_text = File.read('db/bruce_profile.csv')
CSV.parse(csv_text, :headers => true) do |row|
  cust      = Customer.new(row.to_hash.except('name'))
  cust.user = User.new(name:     row['name'],
                       email:    row['name'].downcase + '@example.com',
                       password: 'password', password_confirmation: 'password')
  cust.save
  puts "#{1}:#{cust.user.name}:#{cust.inspect}"
end
puts "Loaded #{Customer.count} customers."


# Load the twitter personalities
i = 1
CSV.foreach('db/bruce_twitter.csv', headers: true) do |row|
  tp   = TwitterPersonality.create(row.to_hash.except('category'))
  cust = Customer.joins(:user).where(users: { name: tp.username }).first
  cust.twitter_personality = tp
  tp.save
end
puts "Loaded #{TwitterPersonality.count} twitter personalities."


# # Load the transaction categories
# CSV.foreach('db/transaction_categories.csv', headers: true) do |row|
#   TransactionCategory.create!(id: row[1], name: row[0])
# end
# puts "Loaded #{TransactionCategory.count} transaction categories."
# 
# 


customer = Customer.first
CSV.foreach('db/bruce_transactions.csv', headers: true) do |row|

  # add the transaction
  customer.transactions.build(customer_id: row['CUSTID'],
                              date:        Date.strptime(row['DATE'], '%m/%d/%Y'),
                              # amount:                  row['transaction_amount'],
                              category: row['CATEGORY'])
end
customer.save

User.create!(name:     'David Thomason', email: 'david@example.com',
             password: 'password', password_confirmation: 'password',
             admin:    true)

User.create!(name:     'Avijit Chatterjee', email: 'avijit@example.com',
             password: 'password', password_confirmation: 'password',
             admin:    true)

puts "Loaded #{MlScoringService.count} ML Scoring Services."