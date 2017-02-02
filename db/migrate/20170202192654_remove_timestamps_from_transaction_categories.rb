class RemoveTimestampsFromTransactionCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :transaction_categories, :created_at, :string
    remove_column :transaction_categories, :updated_at, :string
  end
end
