class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.boolean :gender
      t.date :birth_date
      t.integer :education
      t.boolean :marital_status
      t.integer :children_count
      t.string :city
      t.string :zip_code
      t.integer :annual_income
      t.integer :client_importance
      t.integer :client_potential
      t.string :twitter_id

      t.timestamps
    end
  end
end
