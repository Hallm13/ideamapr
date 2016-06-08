class AddOrderingToIdeaAssignments < ActiveRecord::Migration
  def change
    add_column :idea_assignments, :ordering, :integer
  end
end
