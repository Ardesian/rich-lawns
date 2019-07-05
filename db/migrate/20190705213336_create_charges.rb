class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :stripe_cards do |t|
      t.belongs_to :user
      t.boolean :default

      t.string :customer_id
      t.string :last_4
      t.integer :exp_month
      t.integer :exp_year

      t.string :customer_error

      t.timestamps
    end

    create_table :stripe_charges do |t|
      t.belongs_to :stripe_card

      t.integer :cost_in_pennies
      t.string :payment_error
      t.datetime :charged_at

      t.timestamps
    end

    create_table :service_charges do |t|
      t.belongs_to :user
      t.belongs_to :service_address
      t.belongs_to :stripe_charge

      t.timestamps
    end
  end
end
