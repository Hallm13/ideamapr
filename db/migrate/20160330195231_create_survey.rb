class CreateSurvey < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :title
      t.integer :owner_id

      t.timestamps
    end
  end
end
