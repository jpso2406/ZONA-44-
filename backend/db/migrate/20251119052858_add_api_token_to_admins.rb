class AddApiTokenToAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :admins, :api_token, :string
    add_index :admins, :api_token
  end
end
