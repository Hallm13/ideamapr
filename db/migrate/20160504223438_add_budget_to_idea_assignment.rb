class AddBudgetToIdeaAssignment < ActiveRecord::Migration
  def change
    add_column :idea_assignments, :budget, :float
  end
end
