# == Schema Information
#
# Table name: service_items
#
#  id                   :bigint           not null, primary key
#  service_job_id       :bigint
#  description          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  unit_count_fraction  :integer
#  unit_cost_in_pennies :integer
#  cost_in_pennies      :integer
#

class ServiceItem < ApplicationRecord
  include Dollarable
  belongs_to :service_job

  scope :not_default, -> { where.not(description: ServiceJob.default_service_item_names) }

  before_validation :set_cost

  dollarable(:unit_count_fraction, :unit_count)
  dollarable(:unit_cost_in_pennies, :unit_cost_in_dollars)

  def cost_in_dollars
    pennies_to_dollars(cost_in_pennies)
  end

  private

  def set_cost
    self.cost_in_pennies = (unit_count.to_f * unit_cost_in_pennies.to_i).round
  end

end
