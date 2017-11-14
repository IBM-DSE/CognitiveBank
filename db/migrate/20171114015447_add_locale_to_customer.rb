class AddLocaleToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :locale, :string
  end
end
