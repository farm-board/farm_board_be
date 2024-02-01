class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :location
      t.text :skills, array: true, default: []
      t.text :bio

      t.timestamps
    end

    add_index :employees, :email, unique: true
    add_index :employees, :phone, unique: true
  end
end
