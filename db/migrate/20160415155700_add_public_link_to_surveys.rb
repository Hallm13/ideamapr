class AddPublicLinkToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :public_link, :string
  end
end
