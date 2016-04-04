class CreateQuestionAssignments < ActiveRecord::Migration
  def change
    create_table :question_assignments do |t|
      t.integer :survey_id
      t.integer :survey_question_id

      t.timestamps
    end
  end
end
