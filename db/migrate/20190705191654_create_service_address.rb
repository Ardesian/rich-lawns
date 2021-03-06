class CreateServiceAddress < ActiveRecord::Migration[5.2]
  def change
    create_table :service_addresses do |t|
      t.string :token
      t.belongs_to :user
      t.string :name
      t.string :address
      t.string :city
      t.string :zip

      t.integer :frequency
      t.datetime :last_service

      t.datetime :removed_at

      t.timestamps
    end
  end
end
