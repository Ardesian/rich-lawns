# == Schema Information
#
# Table name: service_items
#
#  id                   :bigint           not null, primary key
#  service_job_id       :bigint
#  description          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  unit_count           :integer
#  unit_cost_in_pennies :integer
#  cost_in_pennies      :integer
#

class ServiceItem < ApplicationRecord
  belongs_to :service_job

  scope :not_default, -> { where.not(description: ServiceJob.default_service_item_names) }

  validates :unit_count, :unit_cost_in_pennies, :cost_in_pennies, presence: true
  before_validation :set_cost

  def cost_in_pennies
    unit_count.to_i * unit_cost_in_pennies.to_i
  end

  def cost_in_dollars
    (cost_in_pennies / 100.to_f).round(2)
  end

  private

  def set_cost
    self.cost_in_pennies = unit_count.to_i * unit_cost_in_pennies.to_i
  end
end
