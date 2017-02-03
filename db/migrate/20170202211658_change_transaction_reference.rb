class ChangeTransactionReference < ActiveRecord::Migration[5.0]
  def change
    remove_reference :transactions, :user
    add_reference :transactions, :customer
  end
end
