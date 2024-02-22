class AddUserIdToFarmsAndEmployees < ActiveRecord::Migration[7.1]
  def change
    add_reference :farms, :user, null: false, foreign_key: true
    add_reference :employees, :user, null: false, foreign_key: true
  end
end
