class CleanIpVisitsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1

  # An IP is kept far longer than its log rows, because the count IS the
  # record: it's what tells a regular from a stranger, across a quiet spell.
  RETENTION = 90.days
  # Strictly one visit. A second request is the signal of a real visitor
  # rather than a scanner passing through, and those are kept forever.
  ONE_OFF_VISITS = 1
  BATCH_SIZE = 5_000

  def perform
    scope = IpVisit.where("visit_count <= ?", ONE_OFF_VISITS)
    scope = scope.where("last_seen_at < ?", RETENTION.ago)

    deleted = 0
    scope.in_batches(of: BATCH_SIZE) { |batch| deleted += batch.delete_all }
    vacuum! if deleted.positive?

    deleted
  end

  private

  # Plain VACUUM, not FULL: FULL takes an exclusive lock, and every request
  # writes to this table.
  def vacuum!
    connection = ActiveRecord::Base.connection
    # VACUUM cannot run inside a transaction block.
    return if connection.transaction_open?

    connection.execute("VACUUM ANALYZE ip_visits")
  end
end
