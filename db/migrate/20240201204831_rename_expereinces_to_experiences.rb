class RenameExpereincesToExperiences < ActiveRecord::Migration[7.1]
  def change
    rename_table :expereinces, :experiences
  end
end
