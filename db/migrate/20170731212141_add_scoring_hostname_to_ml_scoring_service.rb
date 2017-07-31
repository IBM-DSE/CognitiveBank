class AddScoringHostnameToMlScoringService < ActiveRecord::Migration[5.0]
  def change
    add_column :ml_scoring_services, :scoring_hostname, :string
  end
end
