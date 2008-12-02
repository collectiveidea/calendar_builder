module CalendarBuilder
  module CoreExt
    module Time
      DAYNAME_SYMBOLS = Date::DAYNAMES.collect {|day| day.downcase.to_sym }
      
      # Returns a new Time representing the "start" of this week (Monday, 0:00)
      def beginning_of_week(starts_on = :monday)
        (self - days_since(starts_on)).midnight
      end
      alias :monday :beginning_of_week
      alias :at_beginning_of_week :beginning_of_week
      
      # # Returns a new Time representing the end of this week (Sunday, 23:59:59)
      def end_of_week(ends_on = :sunday)
        (self + days_from(ends_on)).end_of_day
      end
      alias :at_end_of_week :end_of_week
      
    private
      
      def days_since(day)
        wday = DAYNAME_SYMBOLS.index(day)
        wday = wday - 7 if wday > self.wday
        (self.wday - wday).days
      end
      
      def days_from(day)
        wday = DAYNAME_SYMBOLS.index(day)
        wday = wday + 7 if wday < self.wday
        (wday - self.wday).days
      end
      
    end
  end
end

Time.send :include, CalendarBuilder::CoreExt::Time