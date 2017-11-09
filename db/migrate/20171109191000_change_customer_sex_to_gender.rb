class ChangeCustomerSexToGender < ActiveRecord::Migration[5.0]
  def change
    rename_column :customers, :sex, :gender
  end
end
