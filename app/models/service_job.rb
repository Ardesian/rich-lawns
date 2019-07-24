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
  belongs_to :invoice
  belongs_to :service_address
  has_many :service_items

  def default_service_items
    [
      "Mowing",
      "Weeding",
      "Hedging",
      "Tree/shrub removal",
      "Clean up"
    ]
  end

  def cost
    5 # Sum items
  end
end
