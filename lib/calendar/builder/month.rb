require 'builder'

module Calendar
  module Builder
    
    class Day
      attr_accessor :date, :id, :css_classes
      def initialize(date, calendar)
        @date = date
        @calendar = calendar
        @css_classes = ['day']
        @css_classes << "other_month" unless self.during_month?
        @css_classes << "weekend" if self.weekend?
      end
      
      def during_month?
        (@calendar.beginning_of_month..@calendar.end_of_month).include?(@date)
      end
      
      def weekend?
        [0, 6].include?(@date.wday)
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
        (beginning_of_month..end_of_month).each do |date|
          day = Day.new(date, self)
          @days[date] = { :day => day, :content => capture(day, &block) }
        end
      end

      def to_s
        doc = ::Builder::XmlMarkup.new(:indent => 4)
        doc.table :id => options[:id] do
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
                self.days_in_week(week).each do |date|
                  day = self.days[date] ? self.days[date][:day] : Day.new(date, self)
                  content = self.days[date] ? self.days[date][:content] : date.mday.to_s
                  doc.td :class => day.css_classes.join(" ") do |cell|
                    cell << content
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