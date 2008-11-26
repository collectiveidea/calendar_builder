require 'calendar_builder/day'
require 'calendar_builder/week'
require 'calendar_builder/month'
require 'calendar_builder/rolling_month'

module CalendarBuilder
  DAYNAME_SYMBOLS = Date::DAYNAMES.collect {|day| day.downcase.to_sym }

  def self.for(type)
    const_get(type.to_s.camelize)
  end
end