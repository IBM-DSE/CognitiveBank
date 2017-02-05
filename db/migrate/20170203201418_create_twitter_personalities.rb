class CreateTwitterPersonalities < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_personalities do |t|
      t.references :customer, foreign_key: true
      t.string :personality
      t.string :values
      t.string :needs

      t.timestamps
    end
  end
end
