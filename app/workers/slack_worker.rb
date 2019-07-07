require 'slack-notifier'
class SlackWorker
  include Sidekiq::Worker
  WEBHOOK_URL = ENV["RICH_SLACK_HOOK"]

  # https://api.slack.com/docs/attachments

  def perform(message, channel='#rich-lawns', username='Help-Bot', icon_emoji='', attachments=[])
    ::Slack::Notifier.new(WEBHOOK_URL, channel: channel, username: username, icon_emoji: icon_emoji, attachments: attachments).ping(message)
  end

end
