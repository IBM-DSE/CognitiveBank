class AddFieldsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :sex, :string
    add_column :customers, :education, :integer
    add_column :customers, :investment, :integer
    add_column :customers, :income, :integer
    add_column :customers, :activity, :integer
    add_column :customers, :yrly_amt, :float
    add_column :customers, :avg_daily_tx, :float
    add_column :customers, :yrly_tx, :integer
    add_column :customers, :avg_tx_amt, :float
    add_column :customers, :negtweets, :integer
    add_column :customers, :state, :string
    add_column :customers, :education_group, :string
  end
end
