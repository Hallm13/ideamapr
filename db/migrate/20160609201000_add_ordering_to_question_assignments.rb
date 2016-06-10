class AddOrderingToQuestionAssignments < ActiveRecord::Migration
  def change
    add_column :question_assignments, :ordering, :integer
  end
end
