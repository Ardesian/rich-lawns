# == Schema Information
#
# Table name: service_jobs
#
#  id                 :bigint           not null, primary key
#  invoice_id         :bigint
#  service_address_id :bigint
#  date               :date
#  notes              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ServiceJob < ApplicationRecord
  include Dollarable
  belongs_to :invoice, optional: true
  belongs_to :service_address
  has_many :service_items

  accepts_nested_attributes_for :service_items, allow_destroy: true

  def self.default_services
    {
      "Mowing"             => 25,
      "Weeding"            => 20,
      "Hedging"            => 20,
      "Tree/shrub removal" => 20,
      "Clean up"           => 20
    }
  end

  def self.default_service_item_names
    default_services.keys
  end
  delegate :default_services, to: :class
  delegate :default_service_item_names, to: :class

  def cost_in_pennies
    service_items.sum(:cost_in_pennies)
  end

  def cost_in_dollars
    pennies_to_dollars(cost_in_pennies)
  end

  def generate_invoice
    invoice = service_address.user.invoices.create
    update(invoice: invoice)
    invoice
  end
end
