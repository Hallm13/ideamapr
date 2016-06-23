class ChangeResponseStructure < ActiveRecord::Migration
  def up
    add_column :responses, :closed, :boolean
    remove_column :responses, :payload
  end
  
  def down
    remove_column :responses, :closed
    remove_column :responses, :payload, :text
  end  
end
