class AddSetupCompleteToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :setup_complete, :boolean, default: false
  end
end
