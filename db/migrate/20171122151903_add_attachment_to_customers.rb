class AddAttachmentToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :customers, :custom_img
  end
end
