class AddSetupCompleteToFarms < ActiveRecord::Migration[7.1]
  def change
    add_column :farms, :setup_complete, :boolean, default: false
  end
end
