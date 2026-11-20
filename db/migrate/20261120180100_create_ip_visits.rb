class CreateIpVisits < ActiveRecord::Migration[5.2]
  def up
    create_table(:ip_visits) { |t|
      t.string(:ip_address, null: false)
      t.integer(:visit_count, null: false, default: 0)
      t.datetime(:first_seen_at)
      t.datetime(:last_seen_at)
      t.timestamps
    }

    # The upsert conflict target — every request looks the row up by IP.
    add_index(:ip_visits, :ip_address, unique: true)
    # Serves CleanIpVisitsWorker's "single visit, long gone" sweep.
    add_index(:ip_visits, [:visit_count, :last_seen_at])

    # Seeded from the log before DropLogTrackersWorker starts trimming it, so a
    # returning visitor keeps their count rather than reading as new.
    execute(
      <<~SQL.squish,
        INSERT INTO ip_visits
          (ip_address, visit_count, first_seen_at, last_seen_at, created_at, updated_at)
        SELECT ip_address, COUNT(*), MIN(created_at), MAX(created_at), NOW(), NOW()
        FROM log_trackers
        WHERE ip_address IS NOT NULL
        GROUP BY ip_address
      SQL
    )
  end

  def down
    drop_table(:ip_visits)
  end
end
