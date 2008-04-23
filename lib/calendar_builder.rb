require 'core_ext/time'
require 'calendar/builder'
require 'calendar/builder/proxy'
require 'calendar/builder/day'
require 'calendar/builder/week'
require 'calendar/builder/month'
require 'calendar/builder/rolling_month'

module CollectiveIdea
  module CalendarBuilder
    
    def calendar_builder(type = :month, options = {}, &block)
      returning Calendar::Builder.for(type).new(options) do |cal|
        yield cal if block_given?
      end
    end
    
    def calendar(options = {}, &block)
      cal = Calendar::Builder.for(options.delete(:type) || :month).new(options)
      if block_given?
        cal.each(&block)
        concat cal.to_s, block.binding
      else
        cal
      end
    end
    
  end
end