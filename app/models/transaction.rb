class Transaction < ApplicationRecord
  belongs_to :customer
  belongs_to :transaction_category
  
  # def category
  #   self.transaction_category.name if self.transaction_category
  # end
end
