module Calendar
  module Builder
    
    class Week < Base
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::CaptureHelper
      
      def initialize(options = {})
        super({
          :date => Date.today,
          :first_day_of_week => 0,
          :day_label_format => "%a, %b %d"
        }.merge(options))
        @days = {}
      end
      
      def date
        @options[:date]
      end
      
      def each(&block)
        (begin_on..end_on).each do |date|
          proxy = Proxy.new(date, self)
          @days[date] = { :proxy => proxy, :content => capture(proxy, &block) }
        end
      end
      
      def begin_on
        beginning_of_week
      end
      
      def end_on
        end_of_week
      end
      
      def to_s
        doc = ::Builder::XmlMarkup.new(:indent => 4)
        doc.table :id => options[:id], :class => 'calendar', :cellspacing => 0, :cellpadding => 0 do
          doc.thead do
            doc.tr do
              (beginning_of_week..end_of_week).each do |day|
                doc.th day.strftime(options[:day_label_format]),
                  :class => Proxy.new(day, self).css_classes.join(" ")
              end
            end
          end
          doc.tbody do 
            doc.tr do
              days_in_week.each do |date|
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

      def days_in_week(date = options[:date])
        (beginning_of_week(date)..end_of_week(date)).to_a
      end
      
      def beginning_of_week(date = options[:date])
        date - days_between(options[:first_day_of_week], date.wday)
      end
      
      def beginning_of_week?(date = options[:date])
        date == beginning_of_week(date)
      end

      def end_of_week(date = options[:date])
        date + days_between(date.wday, options[:first_day_of_week] - 1)
      end

      def end_of_week?(date = options[:date])
        date == end_of_week(date)
      end

      
      def add_default_classes(proxy)
        proxy.css_classes = ['day']
        proxy.css_classes << "weekend" if weekend?(proxy.date)
        proxy.css_classes << "first" if beginning_of_week?(proxy.date)
        proxy.css_classes << "last" if end_of_week?(proxy.date)
        proxy.css_classes << "today" if Date.today == proxy.date
        proxy
      end

      def weekend?(date)
        [0, 6].include?(date.wday)
      end
      
      def next
        self.class.new(@options.merge(:date => @options[:date] + 7))
      end

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
end