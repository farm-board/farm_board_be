class AddMarketplaceColumnsToEmployeesAndFarms < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :marketplace_phone, :string
    add_column :employees, :marketplace_email, :string
    add_column :farms, :marketplace_phone, :string
    add_column :farms, :marketplace_email, :string
  end
end
