require 'builder'

module CalendarBuilder
  class Day < Base
    attr_accessor :options
    
    def initialize(options = {})
      super({
        :begin_hour => 7,
        :end_hour => 18,
        :day_label_format => "%A, %B %d, %Y",
      }.merge(options))
    end
    
    def day_label_format
      options[:day_label_format]
    end
    
    def days
      [date]
    end
    
    def begin_on
      date.to_time.beginning_of_day
    end
    alias_method :begin_at, :begin_on
    
    def end_on
      date.to_time.end_of_day
    end
    alias_method :end_at, :end_on
    
    def hours
      (options[:begin_hour]..options[:end_hour]).collect do |hour|
        date.to_time.change :hour => hour
      end
    end
    
    def next
      day = Day.new(options.merge(:date => date + 1))
      day = day.next while options[:except].include?(DAYNAME_SYMBOLS[day.date.wday])
      day
    end
    
    def previous
      day = Day.new(options.merge(:date => date - 1))
      day = day.previous while options[:except].include?(DAYNAME_SYMBOLS[day.date.wday])
      day
    end
  end
end
