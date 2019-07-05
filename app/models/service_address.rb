# == Schema Information
#
# Table name: service_addresses
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  name         :string
#  address      :string
#  city         :string
#  zip          :string
#  frequency    :integer
#  last_service :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ServiceAddress < ApplicationRecord
  belongs_to :user

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

  defaults frequency: :weekly

  def self.select_frequencies
    frequencies.keys.map do |frequency|
      name = frequency.titleize.gsub(/(bi|semi)/i, '\1-')
      [name, frequency]
    end
  end
end
