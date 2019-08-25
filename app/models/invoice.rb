# == Schema Information
#
# Table name: invoices
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  stripe_charge_id :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  paid_at          :datetime
#  sent_at          :datetime
#  sent_to_email    :string
#  token            :string
#

class Invoice < ApplicationRecord
  include Dollarable
  belongs_to :user, optional: true # Want Rich to be able to send these to guests
  belongs_to :stripe_charge, optional: true # If nil, charge failed/is pending
  has_many :service_jobs
  has_many :service_items, through: :service_jobs

  def cost_in_pennies
    service_items.sum(:cost_in_pennies)
  end

  def cost_in_dollars
    pennies_to_dollars(cost_in_pennies)
  end

  def pending?
    !paid? && !!stripe_charge.try(:pending?)
  end

  def paid?
    paid_at? || stripe_charge.try(:success?)
  end

  def recipient
    sent_to_email.presence || user.try(:email)
  end

  def mark_paid(time=Time.current)
    update(paid_at: time)
  end
end
