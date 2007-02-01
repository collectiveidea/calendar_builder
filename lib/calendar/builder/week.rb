module Calendar
  module Builder
    
    class Week < Base
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::CaptureHelper
      
      attr_accessor :days
      
      def initialize(options = {})
        super({
          :date => Date.today,
          :first_day_of_week => 0,
        }.merge(options))
        @days = {}
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
        doc.table :id => options[:id] do
          doc.thead do
            doc.tr do
              self.days_of_week.each do |day|
                doc.th day, :class => 'day'
              end
            end
          end
          doc.tbody do 
            doc.tr do
              self.days_in_week.each do |date|
                proxy = self.days[date] ? self.days[date][:proxy] : Proxy.new(date, self)
                content = self.days[date] ? self.days[date][:content] : date.mday.to_s
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
      
      def days_of_week
        @days_of_week ||= returning((options[:abbreviate_labels] ? Date::ABBR_DAYNAMES : Date::DAYNAMES).dup) do |day_names|
          self.options[:first_day_of_week].times do
            day_names.push(day_names.shift)
          end
        end
      end

      def beginning_of_week(date = options[:date])
        date - days_between(options[:first_day_of_week], date.wday)
      end

      def end_of_week(date = options[:date])
        date + days_between(date.wday, options[:first_day_of_week] - 1)
      end
      
      def add_default_classes(proxy)
        proxy.css_classes = ['day']
        proxy.css_classes << "weekend" if weekend?(proxy.date)
        proxy
      end

      def weekend?(date)
        [0, 6].include?(date.wday)
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