class AddTimestampsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column(:customers, :created_at, :datetime)
    add_column(:customers, :updated_at, :datetime)
  end
end
