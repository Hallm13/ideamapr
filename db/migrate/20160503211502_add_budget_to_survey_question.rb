class AddBudgetToSurveyQuestion < ActiveRecord::Migration
  def change
    add_column :survey_questions, :budget, :float
  end
end
