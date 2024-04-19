class AddFieldsToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :phone, :string
    add_column :employees, :email, :string
    add_column :employees, :image, :string
  end
end
