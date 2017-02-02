class AddContextToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :context, :text
  end
end
