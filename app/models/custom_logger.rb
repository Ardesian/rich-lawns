class CustomLogger
  class << self

    def log_request(request, user=nil)
      filtered_params = filter_hash(request.env["action_dispatch.request.parameters"])
      log("#{request.env["REQUEST_METHOD"]} - #{request.env['REQUEST_PATH']} #{filtered_params}", user, request)
    end

    def log_blip!(with_color="\e[0m")
      File.open("log/custom_logger.txt", "a+") { |f| f << "#{with_color}.\e[0m" }
    end

    def log(message, user=nil, request=nil)
      return if Rails.env.development?
      if request.nil?
        ip_address = "No IP"
      else
        ip_address = "IP: #{request.try(:remote_ip)}\n"
      end
      display_name = user.present? ? "#{user.try(:id)}: #{user.try(:username)}\n" : ''
      formatted_time = Time.zone.now.in_time_zone('America/Denver')
      message_to_log = "\n#{formatted_time.strftime('%b %d, %Y %H:%M:%S.%L')} - #{message}\n#{ip_address}#{display_name}\n"
      if request
        filtered_params = filter_hash(request.env["action_dispatch.request.parameters"])
        LogTracker.create({
          user_agent: request.user_agent,
          ip_address: request.try(:remote_ip),
          http_method: request.env["REQUEST_METHOD"],
          url: request.env["REQUEST_PATH"],
          params: filtered_params,
          headers: request&.headers&.env&.reject { |key| key.to_s.include?('.') },
          body: request.try(:raw_post).to_s.presence || request.try(:body).to_s.presence,
          user_id: user.try(:id),
          created_at: formatted_time
        })
      end
      Rails.logger.info "\nCustomLogger: #{message_to_log}\n\n"
      File.open("log/custom_logger.txt", "a+") { |f| f << message_to_log }
    end

    def filter_hash(hash)
      new_hash = hash.deep_dup
      dangerous_keys = new_hash.keys.grep(/password/)
      dangerous_keys.each { |k| new_hash[k].is_a?(String) ? new_hash[k] = '[[FILTERED PASSWORD]]' : nil }
      new_hash.each do |hash_key, hash_val|
        if hash_val.is_a?(Hash)
          new_hash[hash_key] = filter_hash(new_hash[hash_key])
        end
      end
      new_hash
    end

  end
end
