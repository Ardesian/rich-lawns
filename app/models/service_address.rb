# == Schema Information
#
# Table name: service_addresses
#
#  id           :bigint           not null, primary key
#  token        :string
#  user_id      :bigint
#  name         :string
#  address      :string
#  city         :string
#  zip          :string
#  frequency    :integer
#  last_service :datetime
#  removed_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ServiceAddress < ApplicationRecord
  include Tokenable
  belongs_to :user, optional: true
  has_many :service_jobs

  scope :current, -> { where(removed_at: nil) }

  enum frequency: {
    by_request_only: 0,
    daily:           1,
    # semiweekly:    2,
    weekly:          3,
    biweekly:        4,
    monthly:         5,
    # bimonthly:     6,
    # quarterly:     7,
    # semiannually:  8,
    # annually:      9
  }

  defaults frequency: :by_request_only

  def self.select_frequencies
    frequencies.keys.map do |frequency|
      name = frequency.titleize.gsub(/(bi|semi)/i, '\1-')
      [name, frequency]
    end
  end

  def serviced!
    update(last_service: Time.current)
  end
end
