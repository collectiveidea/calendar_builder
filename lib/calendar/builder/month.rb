require 'builder'

module Calendar
  module Builder
    
    class Day
      attr_accessor :date, :id, :css_classes
      def initialize(date)
        @date = date
        @css_classes = ['day']
      end
      
      def method_missing(method, *args)
        date.send(method, *args)
      end
      
      def to_s
        date.mday.to_s
      end
    end
    
    class Month
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::CaptureHelper
      include ActionView::Helpers::TagHelper
      
      attr_accessor :options, :mab, :days
      
      def initialize(options = {})
        @options = {
          :date => Date.today,
          :first_day_of_week => 0,
          :abbreviate_labels => false,
          :month_format => "%B"
        }.merge(options)
        @days = {}
      end

      def each(&block)
        (beginning_of_month..end_of_month).each do |day|
          @days[day] = capture(Day.new(day), &block)
        end
      end

      def to_s
        doc = ::Builder::XmlMarkup.new(:indent => 4)
        doc.table :id => options[:id] do
          doc.caption options[:caption] if options[:caption]
          doc.thead do
            doc.tr do
              doc.th beginning_of_month.strftime(options[:month_format]), :class => 'month', :colspan => 7
            end
            doc.tr do
              self.days_of_week.each do |day|
                doc.th day, :class => 'day'
              end
            end
          end
          doc.tbody do 
            self.weeks_in_month.times do |week|
              doc.tr do
                self.days_in_week(week).each do |day|
                  doc.td :class => classes_for_day(day) do |cell|
                    cell << (self.days[day] || day.mday.to_s)
                  end
                end
              end
            end
          end
        end
      end
      
      def classes_for_day(date)
        returning [] do |classes|
          classes << "day"
          classes << "other_month" if date < beginning_of_month || date > end_of_month
        end.join(" ")
      end
      
      def days_in_week(week, &block)
        ((beginning_of_week(beginning_of_month) + (week * 7))..(end_of_week(beginning_of_month) + (week * 7))).to_a
      end
      
      def days_of_week
        @days_of_week ||= returning((options[:abbreviate_labels] ? Date::ABBR_DAYNAMES : Date::DAYNAMES).dup) do |day_names|
          self.options[:first_day_of_week].times do
            day_names.push(day_names.shift)
          end
        end
      end
      
      def beginning_of_week(date)
        date - days_between(options[:first_day_of_week], date.wday)
      end
      
      def end_of_week(date)
        date + days_between(date.wday, options[:first_day_of_week] - 1)
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