module CalendarBuilder
  class Base
    attr_accessor :options
    
    def initialize(options = {})
      @options = {
        :date => Date.today
      }.merge(options)
      @options[:date] = @options[:date].to_date rescue Date.today
      @options[:except] = Array(@options[:except])
    end
    
    def type
      self.class.name.demodulize.underscore.to_sym
    end
    
    def date
      options[:date]
    end
    
  end
end
