# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

User.create!(name: 'David Thomason', email: 'david@example.com', password: 'foobar', password_confirmation: 'foobar')
User.create!(id: 1009505380, name: 'Carmela Giuggia', email: 'carmela@example.com', 
             password: 'password', password_confirmation: 'password')
User.create!(id: 1009505390, name: 'Rufo Bragalini', email: 'rufo@example.com', 
             password: 'password', password_confirmation: 'password')

# Load the transactions
CSV.foreach('db/transactions.csv', headers: true) do |row|
  Transaction.create!(user_id: row['Customer_ID'], date: row['Transaction_Date'], 
             category: row['Transaction_Category'], amount: row['Transaction_Amount'])
end

CSV.foreach('db/transaction_categories.csv', headers: true) do |row|
  tc = TransactionCategory.create!(id: row[1], category: row[0])
  puts tc.inspect
end
