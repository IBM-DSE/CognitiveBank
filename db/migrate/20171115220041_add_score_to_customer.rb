class AddScoreToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :score, :text
  end
end
