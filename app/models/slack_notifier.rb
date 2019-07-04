class SlackNotifier

  def self.notify(message, channel: '#rich-lawns', username: 'Help-Bot', icon_emoji: "", attachments: [])
    SlackWorker.perform_async(message, channel, username, icon_emoji, attachments)
  end

end
