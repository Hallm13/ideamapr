class RenameUserIdToOwnerIdForTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :user_id, :owner_id
  end
end
