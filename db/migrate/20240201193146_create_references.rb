class CreateReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :references do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :relationship

      t.timestamps
    end
  end
end
