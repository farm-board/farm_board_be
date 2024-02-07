class AddAgeRequirementToPostings < ActiveRecord::Migration[7.1]
  def change
    add_column :postings, :age_requirement, :integer
  end
end
