module ApplicationHelper
  def parsley(*parsley_values, **parsley_settings)
    parsley_settings[:error_message] ||= parsley_settings.delete(:message) if parsley_settings[:message].present?
    parsley_values << :errors_messages_disabled if parsley_values.delete(:no_message)

    parsley_hash = {}
    parsley_values.each do |present_key|
      parsley_hash["parsley_#{present_key}"] = true
    end
    parsley_settings.each do |option_key, option_val|
      parsley_hash["parsley_#{option_key}"] = option_val
    end
    parsley_hash
  end
end
