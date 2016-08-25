class AddIpAddressToRespondent < ActiveRecord::Migration
  def change
    add_column :respondents, :ip_address, :string
  end
end
