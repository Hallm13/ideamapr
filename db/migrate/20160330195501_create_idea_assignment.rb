class CreateIdeaAssignment < ActiveRecord::Migration
  def change
    create_table :idea_assignments do |t|
      t.integer :survey_id
      t.integer :idea_id

      t.timestamps
    end
  end
end
