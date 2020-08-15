class DefaultEmailForAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :service_addresses, :default_email, :string
  end
end
