class AddCustomersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :customers
  end
end
