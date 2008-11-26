require 'builder'

module CalendarBuilder
  #
  # == Options
  # * <tt>:date</tt>: The date that the calendar should show.  Default is <tt>Date.today</tt>.
  # * <tt>:first_day_of_week</tt>: A symbol or integer (0 == <tt>:sunday</tt>,
  #   6 == <tt>:saturday</tt>) for day of week that the calendar should start on.
  #   Default is <tt>:sunday</tt>
  # * <tt>:day_label_format</tt>: The strftime format for the label
  #
  class Week
    attr_accessor :options
    
    def initialize(options = {})
      self.options = {
        :date => Date.today,
        :first_day_of_week => :sunday,
        :day_label_format => "%a, %b %d",
      }.merge(options)
      self.options[:except] = [self.options[:except]].flatten
      self.options[:date] = self.options[:date].to_date
      @days = {}
    end
    
    def type
      :week
    end
    
    def day_label_format
      options[:day_label_format]
    end
    
    def date
      @options[:date]
    end
    
    def each(&block)
      (begin_on..end_on).each do |date|
        proxy = Proxy.new(date, self)
        @days[date] = { :proxy => proxy, :content => yield(proxy) }
      end
    end
    
    # Date that the calendar begins on
    def begin_on
      beginning_of_week
    end
    
    # Time that the calendar begins at
    def begin_at
      begin_on.to_time
    end
    
    # Date that the calendar ends on
    def end_on
      end_of_week
    end
    
    # Time that the calendar ends at
    def end_at
      end_on.to_time.end_of_day
    end
    
    def to_s
      doc = ::Builder::XmlMarkup.new(:indent => 4)
      doc.table :id => options[:id], :class => 'week calendar', :cellspacing => 0, :cellpadding => 0 do
        doc.thead do
          doc.tr do
            days.each do |day|
              doc.th day.strftime(options[:day_label_format]),
                :class => Proxy.new(day, self).css_classes.join(" ")
            end
          end
        end
        doc.tbody do 
          doc.tr do
            days.each do |date|
              proxy = @days[date] ? @days[date][:proxy] : Proxy.new(date, self)
              content = @days[date] ? @days[date][:content] : date.mday.to_s
              doc.td :class => proxy.css_classes.join(" "), :valign => :top do |cell|
                cell << content
              end
            end
          end
        end
      end
    end
    
    # An integer of the first day of the week
    def first_day_of_week
      @first_day_of_week ||= case options[:first_day_of_week]
      when Numeric then options[:first_day_of_week]
      when Symbol
        DAYNAME_SYMBOLS.index(options[:first_day_of_week])
      else 0
      end
    end

    def days
      (begin_on..end_on).to_a.reject do |day|
        options[:except].include?(DAYNAME_SYMBOLS[day.wday])
      end
    end
    
    # The date of the first day of the week for the given date
    def beginning_of_week(date = options[:date])
      date - days_between(first_day_of_week, date.wday)
    end
    
    # Returns true if the given date falls on the first day of the week
    def beginning_of_week?(date = options[:date])
      date == beginning_of_week(date)
    end

    # The date of the last day of the week for the given date
    def end_of_week(date = options[:date])
      date + days_between(date.wday, first_day_of_week - 1)
    end

    # Returns true if the given date falls on the last day of the week
    def end_of_week?(date = options[:date])
      date == end_of_week(date)
    end

    def default_css_classes(date)
      returning ['day'] do |classes|
        classes << "weekend" if weekend?(date)
        classes << "first" if beginning_of_week?(date)
        classes << "last" if end_of_week?(date)
        classes << "today" if Date.today == date
      end
    end

    # Returns true if the given date falls on a Saturday or Sunday
    def weekend?(date)
      [0, 6].include?(date.wday)
    end
    
    # Returns a new calendar for the next week
    def next
      self.class.new(@options.merge(:date => @options[:date] + 7))
    end

    # Returns a new calendar for previous week
    def previous
      self.class.new(@options.merge(:date => @options[:date] - 7))
    end
    
  private

    def days_between(first, second)
      if first > second
        second + (7 - first)
      else
        second - first
      end
    end

  end
  
end
