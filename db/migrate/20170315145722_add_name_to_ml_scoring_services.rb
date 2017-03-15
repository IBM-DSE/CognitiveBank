class AddNameToMlScoringServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ml_scoring_services, :name, :string
  end
end
