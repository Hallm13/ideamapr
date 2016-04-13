class AddThankyouNoteToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :thankyou_note, :text
  end
end
