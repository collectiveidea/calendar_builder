module Calendar
  module Builder
    class Proxy
      attr_accessor :date, :id, :css_classes
      def initialize(date, calendar)
        @date = date
        @calendar = calendar
        @css_classes = calendar.default_css_classes(date)
        @id = "date_#{date.strftime('%Y-%m-%d')}"
      end
  
      def method_missing(method, *args)
        if date.respond_to?(method)
          date.send(method, *args)
        else
          calendar.send(method, date, *args)
        end
      end
  
      def to_s
        date.mday.to_s
      end
    end
  end
end