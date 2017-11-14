require 'csv'

puts
puts 'Loading the customers and transactions...'
csv_text = File.read('db/bruce_profile.csv')
CSV.parse(csv_text, :headers => true) do |row|
  cust = Customer.new(row.to_hash)
  cust.save
  puts "#{1}:#{cust.user.name}:#{cust.inspect}"
end
puts "Loaded #{Customer.count} customers."


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


# Load transaction fraud data
CSV.foreach('db/data/fraud.csv', headers: true) do |row|
  p row.to_h
  FraudTransaction.create!(row.to_h)
end