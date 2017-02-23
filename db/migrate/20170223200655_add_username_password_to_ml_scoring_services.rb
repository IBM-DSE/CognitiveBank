class AddUsernamePasswordToMlScoringServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ml_scoring_services, :username, :string
    add_column :ml_scoring_services, :password, :string
  end
end
