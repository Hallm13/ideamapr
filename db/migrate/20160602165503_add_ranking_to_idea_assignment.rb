class AddRankingToIdeaAssignment < ActiveRecord::Migration
  def change
    add_column :idea_assignments, :ranking, :integer
  end
end
