class CreatePostingEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :posting_employees do |t|
      t.references :posting, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :notification

      t.timestamps
    end
  end
end
