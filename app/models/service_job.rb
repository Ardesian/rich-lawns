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

  def cost
    5 # Sum items
  end
end
