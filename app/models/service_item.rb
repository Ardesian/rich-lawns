# == Schema Information
#
# Table name: service_items
#
#  id              :bigint           not null, primary key
#  service_job_id  :bigint
#  description     :string
#  cost_in_pennies :integer
#  time_in_minutes :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ServiceItem < ApplicationRecord
  belongs_to :service_job

  scope :not_default, -> { where.not(description: ServiceJob.default_service_item_names) }

  def skippable?
    cost_in_pennies.blank? && time_in_minutes.blank?
  end

  def cost_per_hour
    25
  end

  def cost_per_minute
    cost_per_hour / 60.to_f
  end

  def cost # pennies
    return 0 if skippable?
    return cost_in_pennies if cost_in_pennies.present?
    (cost_per_minute * time_in_minutes).round
  end

  def cost_in_dollars=(new_cost)
    (new_cost / 100.to_f).round
  end

  def cost_in_dollars
    return unless cost_in_pennies.present?
    (cost_in_pennies.to_i * 100.to_f).round(2)
  end
end
