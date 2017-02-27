class CreateMlScorings < ActiveRecord::Migration[5.0]
  def change
    create_table :ml_scorings do |t|
      t.boolean :prediction
      t.float :probability
      t.string :endpoint
      t.string :response

      t.column :created_at, :datetime
    end
  end
end
