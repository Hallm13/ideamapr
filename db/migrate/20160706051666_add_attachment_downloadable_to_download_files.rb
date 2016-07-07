class AddAttachmentDownloadableToDownloadFiles < ActiveRecord::Migration
  def self.up
    change_table :download_files do |t|
      t.attachment :downloadable
    end
  end

  def self.down
    remove_attachment :download_files, :downloadable
  end
end
