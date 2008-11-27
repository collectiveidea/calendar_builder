module CalendarBuilder
  class RollingMonth < Month
    
    def initialize(options = {})
      super({:number_of_weeks => 4}.merge(options))
    end
    
    def begin_on
      beginning_of_week(options[:date])
    end
    
    def end_on
      end_of_week(begin_on + weeks_in_month.weeks)
    end
    
    def weeks_in_month
      options[:number_of_weeks]
    end
    
  end
end
