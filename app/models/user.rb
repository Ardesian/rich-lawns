# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  phone                  :string
#  role                   :integer          default("customer")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include Moddable

  has_many :service_addresses
  has_many :invoices
  has_many :stripe_cards
  has_many :sent_emails, class_name: "Email", foreign_key: :sent_by_id, dependent: :destroy

  after_create :ping_slack

  def invoices_by_email
    Invoice.where("invoices.sent_to_email ILIKE ?", email)
  end

  def default_payment_card
    stripe_cards.current.default.first
  end

  def see!
    # last logged in at NOW
  end

  private

  def ping_slack
    SlackNotifier.notify("New user: #{name}")
  end
end
