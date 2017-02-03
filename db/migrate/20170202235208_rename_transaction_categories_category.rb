class RenameTransactionCategoriesCategory < ActiveRecord::Migration[5.0]
  def change
    rename_column :transaction_categories, :category, :name
  end
end
