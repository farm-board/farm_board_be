class CreateFarms < ActiveRecord::Migration[7.1]
  def change
    create_table :farms do |t|
      t.string :name
      t.string :location
      t.string :email
      t.string :image
      t.text :bio

      t.timestamps
    end
  end
end
