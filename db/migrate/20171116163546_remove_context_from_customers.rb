class RemoveContextFromCustomers < ActiveRecord::Migration[5.0]
  def change
    remove_column :customers, :context
  end
end
