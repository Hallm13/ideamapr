class AddCookieKeyToRespondent < ActiveRecord::Migration
  def change
    add_column :respondents, :cookie_key, :string
  end
end
