module Calendar
  module Builder
    
    class Month < Week
      
      def initialize(options = {})
        super({
          :month_label_format => "%B",
          :day_label_format => "%A"
        }.merge(options))
      end

      def to_s
        doc = ::Builder::XmlMarkup.new(:indent => 4)
        doc.table :id => options[:id], :class => 'calendar', :cellspacing => 0, :cellpadding => 0 do
          doc.thead do
            doc.tr do
              doc.th month, :class => 'month', :colspan => 7
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
              doc.tr do
                week.days.each do |date|
                  proxy = @days[date] ? @days[date][:proxy] : Proxy.new(date, self)
                  content = @days[date] ? @days[date][:content] : date.mday.to_s
                  doc.td :class => proxy.css_classes.join(" ") do |cell|
                    cell << content
                  end
                end
              end
            end
          end
        end
      end
      
      def begin_on
        beginning_of_month
      end
      
      def end_on
        end_of_month
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
        end
      end
      
      def during_month?(date)
        (beginning_of_month..end_of_month).include?(date)
      end
      
      def month
        date.strftime(options[:month_label_format])
      end
      
    end
  end
end