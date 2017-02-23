class CreateMlScoringServices < ActiveRecord::Migration[5.0]
  def change
    create_table :ml_scoring_services do |t|
      
      t.string :hostname
      t.integer :port, :deployment
      
      t.timestamps
    end
  end
end
