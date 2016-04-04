class CreateSurveyQuestion < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.integer :survey_id
      t.integer :question_type

      t.timestamps
    end
  end
end
