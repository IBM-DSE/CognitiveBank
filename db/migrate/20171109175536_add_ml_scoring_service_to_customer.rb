class AddMlScoringServiceToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_reference :customers, :ml_scoring_service, foreign_key: true
  end
end
