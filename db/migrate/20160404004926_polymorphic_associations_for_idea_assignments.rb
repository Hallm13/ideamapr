class PolymorphicAssociationsForIdeaAssignments < ActiveRecord::Migration
  def change
    add_column :idea_assignments, :groupable_type, :string
    add_column :idea_assignments, :groupable_id, :integer
  end
end
