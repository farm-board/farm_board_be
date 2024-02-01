class CreateExpereinces < ActiveRecord::Migration[7.1]
  def change
    create_table :expereinces do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :company_name, null: false
      t.string :started_at, null: false
      t.string :ended_at, null: false
      t.text :description

      t.timestamps
    end
  end
end
