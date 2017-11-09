class RenameCustomerEducationColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :customers, :education, :education_code
    rename_column :customers, :education_group, :education
  end
end
