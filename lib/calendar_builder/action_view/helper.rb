module CalendarBuilder
  module ActionView
    module Helper
      def calendar_builder(type = :month, options = {}, &block)
        returning Calendar::Builder.for(type).new(options) do |cal|
          yield cal if block_given?
        end
      end
  
      def calendar(options = {}, &block)
        cal = Calendar::Builder.for(options.delete(:type) || :month).new(options)
        return cal unless block_given?
        cal.each { |date| capture(date, &block) }
        concat cal.to_s, &block
      end
    end
  end
end