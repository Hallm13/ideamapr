class CreateIndividualAnswers < ActiveRecord::Migration
  def change
    create_table :individual_answers do |t|
      t.integer :response_id
      t.integer :survey_question_id
      t.string :survey_public_link
      t.jsonb :response_data

      t.timestamps
    end
  end
end
