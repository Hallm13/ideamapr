class CreateResponse < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :respondent_id
      t.text :payload
      t.integer :survey_id

      t.timestamps
    end
  end
end
