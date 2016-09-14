class AddThankYouButtonFieldsToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :thankyou_btn_hash, :text
  end
end
