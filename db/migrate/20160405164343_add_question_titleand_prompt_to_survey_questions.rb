class AddQuestionTitleandPromptToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :question_prompt, :string
    add_column :survey_questions, :title, :string
  end
end
