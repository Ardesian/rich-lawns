# == Schema Information
#
# Table name: stripe_charges
#
#  id              :bigint           not null, primary key
#  stripe_card_id  :bigint
#  cost_in_pennies :integer
#  payment_error   :string
#  charged_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class StripeCharge < ApplicationRecord
  scope :success, -> { where.not(charged_at: nil) }
  scope :failed, -> { where.not(payment_error: ['', nil]).where(charged_at: nil) }
  scope :pending, -> { where(charged_at: nil, payment_error: ['', nil]) }

  validates :customer_id, presence: true

  def charged?; charged_at?; end
  def success?; charged?; end
  def failed?; payment_error?; end
  def pending?; !success? && !failed?; end

  def charge
    return fail!(error: "No customer found") unless persisted?
    return true if charged?
    return success! if cost_in_pennies.to_i <= 0

    begin
      charge = Stripe::Charge.create(
        amount: cost_in_pennies,
        currency: 'usd',
        customer: customer_id
      )
    rescue Faraday::ClientError => err
      return fail!(error: err.try(:message)) # Not sure how this happens yet?
    rescue Stripe::CardError => err
      return fail!(error: err.try(:message))
    rescue StandardError => err
      return fail!(error: err.try(:message)) # Not sure how this happens yet?
    end

    success!
  end

  def success!(success_params={})
    self.charged_at ||= DateTime.current
    self.payment_error = nil

    self.save
    true
  end

  def fail!(fail_params={})
    self.payment_error = fail_params[:error] || "Failed to charge card"

    self.save
    false
  end
end
