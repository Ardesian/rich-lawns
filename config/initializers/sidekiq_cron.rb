# Based on UTC time
every_minute = "* * * * *"
daily_9pm = "0 3 * * *"
daily_4am = "0 10 * * *"
monthly_5th_at_11am = "0 17 5 * *"
monthly_15th_at_2pm = "0 20 15 * *"

cron_jobs = [
  # {
  #   name: "Reschedule Items",
  #   class: "RescheduleItemsWorker",
  #   cron: every_minute
  # }
]

if Rails.env.production?
  cron_jobs += [
    {
      name:  "Forget One-Off Visitors",
      class: "CleanIpVisitsWorker",
      cron:  daily_9pm,
    },
    {
      name:  "DropLogTrackers",
      class: "DropLogTrackersWorker",
      cron:  daily_4am,
    },
    # {
    #   name:  "Charge Car",
    #   class: "ChargeCarWorker",
    #   cron:  monthly_15th_at_2pm
    # },
    # {
    #   name:  "Charge Brothers",
    #   class: "ChargeBrothersWorker",
    #   cron:  monthly_5th_at_11am
    # }
  ]
end

Sidekiq::Cron::Job.load_from_array!(cron_jobs)
