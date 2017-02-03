class MoveUserMessagesAndContextToCustomer < ActiveRecord::Migration[5.0]
  def change
    remove_reference :messages, :user
    add_reference :messages, :customer
    
    remove_column :users, :context
    add_column :customers, :context, :text
  end
end
