# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'


# Load the twitter personalities
CSV.foreach('db/bruce_twitter.csv', headers: true) do |row|
  tp = TwitterPersonality.new(row.to_hash.except('category'))
  tp.save
end
puts "Loaded #{TwitterPersonality.count} twitter personalities."


# Load customers 1009557540
# csv_text = File.read('db/customers_cognitive_bank.csv')
# csv      = CSV.parse(csv_text, :headers => true)
# csv.first(220).each_with_index do |row, i|
#   if i < TwitterPersonality.count-2
#     cust                     = Customer.new(row.to_hash)
#     cust.twitter_personality = TwitterPersonality.find(i+1)
#     username                 = cust.twitter_personality.username || "user#{i}"
#     cust.user                = User.new(name:     username,
#                                         email:    username+'@example.com',
#                                         password: 'password', password_confirmation: 'password')
#     cust.save
#     puts "#{i}:#{username}:#{cust.inspect}"
#   elsif i == 19
#     cust                     = Customer.new(row.to_hash)
#     cust.twitter_personality = TwitterPersonality.find_by_username 'Jonathan_Soroff'
#     username                 = cust.twitter_personality.username || "user#{i}"
#     cust.user                = User.new(name:     username,
#                                         email:    username+'@example.com',
#                                         password: 'password', password_confirmation: 'password')
#     cust.save
#     puts "#{i}:#{username}:#{cust.inspect}"
#   elsif i == 218
#     cust                     = Customer.new(row.to_hash)
#     cust.twitter_personality = TwitterPersonality.find_by_username 'gaelgreene'
#     username                 = cust.twitter_personality.username || "user#{i}"
#     cust.user                = User.new(name:     username,
#                                         email:    username+'@example.com',
#                                         password: 'password', password_confirmation: 'password')
#     cust.save
#     puts "#{i}:#{username}:#{cust.inspect}"
#   end
# end

puts 'Loading the customers and transactions...'
csv_text = File.read('db/bruce_profile.csv')
CSV.parse(csv_text, :headers => true) do |row|
  cust                     = Customer.new(row.to_hash)
  cust.twitter_personality = TwitterPersonality.find(1)
  username                 = cust.twitter_personality.username || "user#{i}"
  cust.user                = User.new(name:     username,
                                      email:    username+'@example.com',
                                      password: 'password', password_confirmation: 'password')
  cust.save
  puts "#{1}:#{username}:#{cust.inspect}"
end

puts "Loaded #{Customer.count} customers."

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
                              category:    row['CATEGORY'])
end
customer.save

User.create!(name:     'David Thomason', email: 'david@example.com',
             password: 'password', password_confirmation: 'password',
             admin:    true)

YAML.load_file('test/fixtures/ml_scoring_services.yml').each { |rec| MlScoringService.create!(rec[1]) }
puts "Loaded #{MlScoringService.count} ML Scoring Services."