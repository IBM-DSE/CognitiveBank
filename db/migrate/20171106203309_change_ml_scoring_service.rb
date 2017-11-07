class ChangeMlScoringService < ActiveRecord::Migration[5.0]
  def change
    change_column :ml_scoring_services, :deployment, :string
  end
end
