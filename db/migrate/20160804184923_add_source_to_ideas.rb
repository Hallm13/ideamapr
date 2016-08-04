class AddSourceToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :source, :string
  end
end
