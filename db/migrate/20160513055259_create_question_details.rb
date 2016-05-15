class CreateQuestionDetails < ActiveRecord::Migration
  def change
    create_table :question_details do |t|
      t.integer :survey_question_id
      t.text :details_list

      t.timestamps
    end
  end
end
