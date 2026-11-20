class AddLogTrackerIndexes < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    # Supports DropLogTrackersWorker's `WHERE created_at < ?`.
    add_index :log_trackers, :created_at, algorithm: :concurrently

    # Without it, every lookup by IP reads the whole table.
    add_index :log_trackers, :ip_address, algorithm: :concurrently
  end
end
