class ChangeMessageContentBack < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :content, :string
  end
end
