class AddLocationToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :location, :string
  end
end
