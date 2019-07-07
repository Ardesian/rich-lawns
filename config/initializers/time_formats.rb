Date::DATE_FORMATS[:default] = "%Y-%m-%d"
Time::DATE_FORMATS[:default] = "%Y-%m-%dT%H:%M:%S%:z"

Date::DATE_FORMATS[:standard_with_weekday] = "%a, %-d %b %Y"
Date::DATE_FORMATS[:simple] = "%b %-d, %Y"
Time::DATE_FORMATS[:simple] = "%b %-d, %Y"
Time::DATE_FORMATS[:simple_with_time] = "%b %-d, %Y %-I:%M %p"


class Time
  def local
    in_time_zone("Mountain Time (US & Canada)")
  end
end
