class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.string :message
      t.boolean :watson_response

      t.timestamps
    end
  end
end
