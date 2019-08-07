class AlterTables < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :paid_at, :datetime
    add_column :invoices, :sent_at, :datetime
    add_column :invoices, :sent_to_email, :string
    add_column :invoices, :token, :string

    remove_column :service_items, :cost_in_pennies, :integer
    remove_column :service_items, :time_in_minutes, :integer
    add_column :service_items, :unit_count, :integer
    add_column :service_items, :unit_cost_in_pennies, :integer
    add_column :service_items, :cost_in_pennies, :integer

    ServiceItem.destroy_all
    ServiceJob.destroy_all
    Invoice.destroy_all
  end
end
