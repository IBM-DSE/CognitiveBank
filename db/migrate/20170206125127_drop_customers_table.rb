class DropCustomersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :customers
  end
end
