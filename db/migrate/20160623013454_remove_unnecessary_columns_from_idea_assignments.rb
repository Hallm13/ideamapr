class RemoveUnnecessaryColumnsFromIdeaAssignments < ActiveRecord::Migration
  def up
    remove_column :idea_assignments, :survey_id
    remove_column :idea_assignments, :ranking    
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Removed unnecessary columns, no point putting them back."
  end
end
