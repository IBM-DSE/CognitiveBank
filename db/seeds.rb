# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'


# Load the twitter personalities
CSV.foreach('db/wpi-results-moretweets.csv', headers: true) do |row|
  tp = TwitterPersonality.new(row.to_hash.except('category'))
  tp.save
end
puts "Loaded #{TwitterPersonality.count} twitter personalities."


# Load customers 1009557540
csv_text = File.read('db/customers_cognitive_bank.csv')
csv      = CSV.parse(csv_text, :headers => true)
csv.first(220).each_with_index do |row, i|
  if i < TwitterPersonality.count-2
    cust                     = Customer.new(row.to_hash)
    cust.twitter_personality = TwitterPersonality.find(i+1)
    username = cust.twitter_personality.username || "user#{i}"
    cust.user                = User.new(name:     username,
                                        email:    username+'@example.com',
                                        password: 'password', password_confirmation: 'password')
    cust.save
    puts "#{i}:#{username}:#{cust.inspect}"
  elsif i == 19
    cust                     = Customer.new(row.to_hash)
    cust.twitter_personality = TwitterPersonality.find_by_username 'Jonathan_Soroff'
    username = cust.twitter_personality.username || "user#{i}"
    cust.user                = User.new(name:     username,
                                        email:    username+'@example.com',
                                        password: 'password', password_confirmation: 'password')
    cust.save
    puts "#{i}:#{username}:#{cust.inspect}"
  elsif i == 218
    cust                     = Customer.new(row.to_hash)
    cust.twitter_personality = TwitterPersonality.find_by_username 'gaelgreene'
    username = cust.twitter_personality.username || "user#{i}"
    cust.user                = User.new(name:     username,
                                        email:    username+'@example.com',
                                        password: 'password', password_confirmation: 'password')
    cust.save
    puts "#{i}:#{username}:#{cust.inspect}"
  end
end
puts "Loaded #{Customer.count} customers."


User.create!(name: 'David Thomason', email: 'david@example.com', password: 'foobar', password_confirmation: 'foobar')


# # Load the transaction categories
# CSV.foreach('db/transaction_categories.csv', headers: true) do |row|
#   TransactionCategory.create!(id: row[1], name: row[0])
# end
# puts "Loaded #{TransactionCategory.count} transaction categories."
# 
# 
# puts 'Loading the customers and transactions...'
# customer = Customer.new
# CSV.foreach('db/transactions.csv', headers: true) do |row|
#   
#   if row['twitter_id']
#     
#     # If we've encountered a new user, add it to the database
#     if row['id'].to_i != customer.id
#       customer.save! if customer.id
#       customer = Customer.new
#       Customer.attribute_names.each do |attr_name|
#         customer[attr_name] = row[attr_name]
#       end
#       customer.user = User.new(name:     row['name'], email: row['name'].downcase.split.first+'@example.com',
#                                password: 'password', password_confirmation: 'password')
#       puts "New customer with Twitter ID #{customer.twitter_id}"
#     end
#     
#     # add the transaction
#     customer.transactions.build(customer_id:             row['id'],
#                                 date:                    row['transaction_date'],
#                                 amount:                  row['transaction_amount'],
#                                 transaction_category_id: row['transaction_category_code'])
#   
#   end
# 
# end
