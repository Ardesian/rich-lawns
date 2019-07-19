class CreateLawnItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.belongs_to :user
      t.belongs_to :stripe_charge

      t.timestamps
    end

    create_table :service_jobs do |t|
      t.belongs_to :invoice
      t.belongs_to :service_address
      t.date :date
      t.text :notes
      # has_many :service_items

      t.timestamps
    end

    create_table :service_items do |t|
      t.belongs_to :service_job
      t.string :description
      t.integer :cost_in_pennies
      t.integer :time_in_minutes

      t.timestamps
    end
  end
end
