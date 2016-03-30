class CreateRespondent < ActiveRecord::Migration
  def change
    create_table :respondents do |t|
      t.string :email

      t.timestamps
    end
  end
end
