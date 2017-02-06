class AddContextToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :context, :text
  end
end
