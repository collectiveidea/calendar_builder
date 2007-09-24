
module CollectiveIdea
  module CalendarBuilder
    
    def self.included(base)
      base.helper_method :calendar_builder, :calendar
    end
    
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