class AddTokenToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :token, :string
  end
end
