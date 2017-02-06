class AddReferenceToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_reference :customers, :user, foreign_key: true
  end
end
