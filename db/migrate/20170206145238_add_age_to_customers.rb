class AddAgeToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :age, :integer
  end
end
