class RemoveTokenFromSurveys < ActiveRecord::Migration
  def change
    remove_column :surveys, :token
  end
end
