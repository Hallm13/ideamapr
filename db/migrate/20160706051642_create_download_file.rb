class CreateDownloadFile < ActiveRecord::Migration
  def change
    create_table :download_files do |t|
      t.integer :idea_id

      t.timestamps
    end
  end
end
