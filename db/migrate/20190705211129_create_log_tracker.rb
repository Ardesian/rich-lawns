class CreateLogTracker < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :ip
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :region_name
      t.string :city
      t.string :zip_code
      t.string :time_zone
      t.string :metro_code

      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    create_table :log_trackers do |t|
      t.belongs_to :user
      t.belongs_to :location

      t.string  :url
      t.string  :params
      t.string  :http_method
      t.string  :ip_address
      t.string  :user_agent
      t.integer :ip_count
      t.integer :location_id
      t.text    :headers
      t.text    :body

      t.timestamps
    end
  end
end
