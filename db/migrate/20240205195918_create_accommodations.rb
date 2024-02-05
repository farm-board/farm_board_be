class CreateAccommodations < ActiveRecord::Migration[7.1]
  def change
    create_table :accommodations do |t|
      t.boolean :housing
      t.boolean :transportation
      t.boolean :meals
      t.string :images
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
