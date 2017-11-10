class CreateFraudTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :fraud_transactions do |t|
      t.integer :time
      t.decimal :amount
      t.float :v1
      t.float :v2
      t.float :v3
      t.float :v4
      t.float :v5
      t.float :v6
      t.float :v7
      t.float :v8
      t.float :v9
      t.float :v10
      t.float :v11
      t.float :v12
      t.float :v13
      t.float :v14
      t.float :v15
      t.float :v16
      t.float :v17
      t.float :v18
      t.float :v19
      t.float :v20
      t.float :v21
      t.float :v22
      t.float :v23
      t.float :v24
      t.float :v25
      t.float :v26
      t.float :v27
      t.float :v28
    end
  end
end
