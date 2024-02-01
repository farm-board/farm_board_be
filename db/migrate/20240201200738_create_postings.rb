class CreatePostings < ActiveRecord::Migration[7.1]
  def change
    create_table :postings do |t|
      t.references :farm, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :salary, null: false
      t.boolean :offers_lodging, null: false
      t.string :images
      t.text :skill_requirements, array: true, default: []
      t.string :duration, null: false

      t.timestamps
    end
  end
end
