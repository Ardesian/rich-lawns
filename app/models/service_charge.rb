# == Schema Information
#
# Table name: service_charges
#
#  id                 :bigint           not null, primary key
#  user_id            :bigint
#  service_address_id :bigint
#  stripe_charge_id   :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ServiceCharge < ApplicationRecord
  belongs_to :user
  belongs_to :service_address
  belongs_to :stripe_charge, optional: true # If nil, charge failed/is pending

  def charge(amount_in_pennies)
    new_charge = default_payment_card&.charge(default_payment_card)
    update(stripe_charge: new_charge) if new_charge.success?
  end
end
