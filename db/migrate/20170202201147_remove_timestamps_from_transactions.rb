class RemoveTimestampsFromTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :created_at, :string
    remove_column :transactions, :updated_at, :string
  end
end
