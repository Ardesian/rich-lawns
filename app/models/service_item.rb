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
end
