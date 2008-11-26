module CalendarBuilder
  class Month < Week
    
    def initialize(options = {})
      super({
        :month_label_format => "%B",
        :day_label_format => "%A", 
        :month_classes => 'month calendar',
        :show_month_header => true,
        :month_header_classes => 'month',
        :cellspacing => 0,
        :cellpadding => 0
      }.merge(options))
    end
    
    def type
      :month
    end

    def to_s
      doc = ::Builder::XmlMarkup.new(:indent => 4)
      doc.table :id => options[:id], :class => options[:month_classes], :cellspacing => options[:cellspacing], :cellpadding => options[:cellpadding] do
        doc.thead do
          if options[:show_month_header]
            doc.tr do
              doc.th month, :class => options[:month_header_classes], :colspan => 7
            end
          end
          doc.tr do
            days_of_week.each do |day|
              doc.th day.strftime(options[:day_label_format]),
                :class => Proxy.new(day, self).css_classes.join(" ")
            end
          end
        end
        doc.tbody do
          weeks.each do |week|
            row_classes = []
            row_classes << 'first' if week.beginning_of_week == beginning_of_week(beginning_of_month)
            row_classes << 'last' if week.beginning_of_week == beginning_of_week(end_of_month)
            doc.tr :class => row_classes.join(" ") do
              week.days.each do |date|
                proxy = @days[date] ? @days[date][:proxy] : Proxy.new(date, self)
                content = @days[date] ? @days[date][:content] : date.mday.to_s
                doc.td :id => proxy.id, :class => proxy.css_classes.join(" ") do |cell|
                  cell << content
                end
              end
            end
          end
        end
      end
    end
    
    def begin_on
      beginning_of_week(beginning_of_month)
    end
    
    def end_on
      end_of_week(end_of_month)
    end
    
    def beginning_of_month
      Date.civil(options[:date].year, options[:date].month, 1)
    end

    def end_of_month
      Date.civil(options[:date].year, options[:date].month, -1)
    end
    
    def weeks_in_month
      weeks = 0
      (beginning_of_week(beginning_of_month)..end_of_month).step(7) { weeks += 1 }
      weeks
    end
    
    def days_of_week
      weeks.first.days
    end
    
    def weeks
      (0...weeks_in_month).collect do |i|
        Week.new(@options.merge(:date => beginning_of_week(begin_on) + (7 * i)))
      end
    end
    
    def default_css_classes(date)
      returning super(date) do |classes|
        classes << "other_month" unless during_month?(date)
        classes << "first_day_of_month" if date == beginning_of_month
        classes << "last_day_of_month" if date == end_of_month
      end
    end
    
    def during_month?(date)
      (beginning_of_month..end_of_month).include?(date)
    end
    
    def month
      date.strftime(options[:month_label_format])
    end
    
    # Returns a new calendar for the next week
    def next
      self.class.new(@options.merge(:date => date.to_time + 1.month))
    end

    # Returns a new calendar for previous week
    def previous
      self.class.new(@options.merge(:date => date.to_time - 1.month))
    end
    
  end
end