class AddAuthTokenToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :auth_token, :string
  end
end
