class SlackNotifier

  def self.notify(message, channel: '#rich-lawns', username: 'Mail-Bot', icon_emoji: ":mailbox:", attachments: [])
    SlackWorker.perform_async(message, channel, username, icon_emoji, attachments)
  end

end
