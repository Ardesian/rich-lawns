# == Schema Information
#
# Table name: service_charges
#
#  id                 :bigint           not null, primary key
#  token              :string
#  user_id            :bigint
#  service_address_id :bigint
#  stripe_charge_id   :bigint
#  notes              :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# class ServiceCharge < ApplicationRecord
#   include Tokenable
#
#   belongs_to :user
#   belongs_to :service_address
#   belongs_to :stripe_charge, optional: true # When nil, charge failed/is pending
#
#   delegate :cost_in_dollars, to: :stripe_charge, allow_nil: true
#
#   def charge; 30; end
#   def charge=(dollars)
#     charge_amount_in_pennies((dollars.to_f * 100).round)
#   end
#
#   def charge_amount_in_pennies(amount_in_pennies)
#     new_charge = user.try(:default_payment_card)&.charge(amount_in_pennies)
#     if new_charge.success?
#       SlackNotifier.notify("Successfully charged: #{user.name} $#{cost_in_dollars} | #{notes}")
#     else
#       SlackNotifier.notify("Failed to charge: #{new_charge.payment_error}")
#     end
#     update(stripe_charge: new_charge) if new_charge.present?
#   end
# end
