# == Schema Information
#
# Table name: service_jobs
#
#  id                 :bigint           not null, primary key
#  invoice_id         :bigint
#  service_address_id :bigint
#  date               :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ServiceJob < ApplicationRecord
  belongs_to :invoice
  belongs_to :service_address
end
