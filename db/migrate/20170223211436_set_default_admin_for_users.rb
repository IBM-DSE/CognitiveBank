class SetDefaultAdminForUsers < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :admin, false
  end
end
