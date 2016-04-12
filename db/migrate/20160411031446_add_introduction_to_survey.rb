class AddIntroductionToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :introduction, :text
  end
end
