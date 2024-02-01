class CreateFarms < ActiveRecord::Migration[7.1]
  def change
    create_table :farms do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :image
      t.text :bio

      t.timestamps
    end

    add_index :farms, :email, unique: true
    add_index :farms, :phone, unique: true
  end
end
