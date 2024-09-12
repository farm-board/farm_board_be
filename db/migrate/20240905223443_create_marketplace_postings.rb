class CreateMarketplacePostings < ActiveRecord::Migration[7.1]
  def change
    create_table :marketplace_postings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :price
      t.string :description
      t.string :condition
      t.string :images

      t.timestamps
    end
  end
end
