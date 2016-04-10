class CreateCmsContents < ActiveRecord::Migration
  def change
    create_table :cms_contents do |t|
      t.string :key
      t.text :cms_text

      t.timestamps null: false
    end
  end
end
