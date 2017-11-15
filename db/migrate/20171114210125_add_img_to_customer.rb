class AddImgToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :img, :integer
  end
end
