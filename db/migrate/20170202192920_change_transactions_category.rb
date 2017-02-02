class ChangeTransactionsCategory < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :category
    add_reference :transactions, :transaction_category
  end
end
