# == Schema Information
#
# Table name: stripe_cards
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  default        :boolean
#  customer_id    :string
#  last_4         :string
#  exp_month      :integer
#  exp_year       :integer
#  customer_error :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class StripeCard < ApplicationRecord
  belongs_to :user
  has_many :stripe_charges
  has_many :service_charges, through: :stripe_charges

  after_commit :check_default

  defaults default: true

  def charge(amount_in_pennies)
    new_charge = stripe_charges.create(cost_in_pennies: amount_in_pennies)

    update(customer_error: new_charge.payment_error) unless new_charge.charge
    
    new_charge
  end

  def stripe_token=(token)
    customer = Stripe::Customer.create(
      source: token,
      description: "User[#{user.try(:id)}] - #{description}"
    )
    return if customer.try(:id).nil?
    self.customer_id = customer.id
    source = customer.try(:sources).try(:data).try(:first)
    return if source.nil?
    self.last_4 = source.last4
    self.exp_month = source.exp_month
    self.exp_year = source.exp_year
  rescue Stripe::InvalidRequestError => err
    self.customer_error = "Token already used. No charge was made. Please try again."
  end

  private

  def check_default
    return unless default?
    user.stripe_cards.where.not(id: id).update_all(default: false)
  end
end
