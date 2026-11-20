class TuneAutovacuumForLogTrackers < ActiveRecord::Migration[5.2]
  # The global scale factor of 0.2 only vacuums once a fifth of the table is
  # dead. DropLogTrackersWorker deletes a day's rows every night, which never
  # gets near that, so dead rows and stale planner stats would pile up.
  #
  # Storage parameters are not captured in schema.rb, so a schema-loaded
  # database won't have them. That's intentional; this is production tuning.
  def up
    execute(
      <<~SQL.squish,
        ALTER TABLE log_trackers SET (
          autovacuum_vacuum_scale_factor = 0.02,
          autovacuum_analyze_scale_factor = 0.01
        )
      SQL
    )
  end

  def down
    execute(
      <<~SQL.squish,
        ALTER TABLE log_trackers RESET (
          autovacuum_vacuum_scale_factor,
          autovacuum_analyze_scale_factor
        )
      SQL
    )
  end
end
