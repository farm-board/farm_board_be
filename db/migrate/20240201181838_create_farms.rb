class CreateFarms < ActiveRecord::Migration[7.1]
  def change
    create_table :farms do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :image
      t.text :bio

      t.timestamps
    end
  end
end
