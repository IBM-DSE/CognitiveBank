class AddUsernameToTwitterPersonalities < ActiveRecord::Migration[5.0]
  def change
    add_column :twitter_personalities, :username, :string
  end
end
