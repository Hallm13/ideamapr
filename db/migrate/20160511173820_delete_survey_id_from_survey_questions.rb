class DeleteSurveyIdFromSurveyQuestions < ActiveRecord::Migration
  def up
    remove_column :survey_questions, :survey_id
  end

  def down
    add_column :survey_questions, :survey_id, :integer
  end
end
