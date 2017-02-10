class ChangeTransactionsCategoryId < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :category, :string
  end
end
