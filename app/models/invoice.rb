# == Schema Information
#
# Table name: invoices
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  stripe_charge_id :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :stripe_charge, optional: true # If nil, charge failed/is pending
end
