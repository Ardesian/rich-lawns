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
  belongs_to :invoice, optional: true
  belongs_to :service_address
  has_many :service_items

  accepts_nested_attributes_for :service_items, allow_destroy: true

  def self.default_service_item_names
    [
      "Mowing",
      "Weeding",
      "Hedging",
      "Tree/shrub removal",
      "Clean up"
    ]
  end
  delegate :default_service_item_names, to: :class

  def cost_in_pennies
    service_items.sum(:cost_in_pennies)
  end

  def cost_in_dollars
    (cost_in_pennies / 100.to_f).round(2)
  end

  def generate_invoice
    invoice = service_address.user.invoices.create
    update(invoice: invoice)
    invoice
  end
end
