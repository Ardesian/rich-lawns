# == Schema Information
#
# Table name: ip_visits
#
#  id            :bigint           not null, primary key
#  ip_address    :string           not null
#  visit_count   :integer          default(0), not null
#  first_seen_at :datetime
#  last_seen_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class IpVisit < ApplicationRecord
  validates :ip_address, presence: true, uniqueness: true

  # Counts this request and returns how many came before it, which is what
  # `log_trackers.ip_count` has always meant, so an unseen IP still reports 0.
  #
  # One statement rather than find-then-update, because concurrent requests
  # from the same IP would otherwise race and lose increments.
  def self.record!(ip_address)
    return 0 if ip_address.blank?

    now = Time.current
    sql = <<~SQL.squish
      INSERT INTO ip_visits
        (ip_address, visit_count, first_seen_at, last_seen_at, created_at, updated_at)
      VALUES (?, 1, ?, ?, ?, ?)
      ON CONFLICT (ip_address) DO UPDATE SET
        visit_count = ip_visits.visit_count + 1,
        last_seen_at = EXCLUDED.last_seen_at,
        updated_at = EXCLUDED.updated_at
      RETURNING visit_count
    SQL
    result = connection.exec_query(
      sanitize_sql_array([sql, ip_address, now, now, now, now]),
      "IpVisit Upsert",
    )

    result.first["visit_count"].to_i - 1
  end
end
