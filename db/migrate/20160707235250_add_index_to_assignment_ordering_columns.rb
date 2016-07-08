class AddIndexToAssignmentOrderingColumns < ActiveRecord::Migration
  def change
    add_index :question_assignments, :ordering, name: 'index_orderings_in_question_assignments'
    add_index :idea_assignments, :ordering, name: 'index_orderings_in_idea_assignments'
  end
end
