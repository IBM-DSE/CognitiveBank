class AddChurnToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :churn_prediction, :boolean
    add_column :customers, :churn_probability, :float
  end
end
