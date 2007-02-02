module Calendar
  module Builder
    
    class Month < Week
      
      def initialize(options = {})
        super({
          :month_format => "%B",
          :day_label_format => "%A"
        }.merge(options))
      end

      def to_s
        doc = ::Builder::XmlMarkup.new(:indent => 4)
        doc.table :id => options[:id], :class => 'calendar', :cellspacing => 0, :cellpadding => 0 do
          doc.thead do
            doc.tr do
              doc.th beginning_of_month.strftime(options[:month_format]), :class => 'month', :colspan => 7
            end
            doc.tr do
              (beginning_of_week..end_of_week).each do |day|
                doc.th day.strftime(options[:day_label_format]),
                  :class => Proxy.new(day, self).css_classes.join(" ")
              end
            end
          end
          doc.tbody do 
            weeks_in_month.times do |week|
              doc.tr do
                days_in_week(beginning_of_month + (week * 7)).each do |date|
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
      
      def add_default_classes(proxy)
        super(proxy)
        proxy.css_classes << "other_month" unless during_month?(proxy.date)
        proxy
      end
      
      def during_month?(date)
        (beginning_of_month..end_of_month).include?(date)
      end
      
    end
  end
end