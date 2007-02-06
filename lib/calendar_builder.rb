
module CollectiveIdea
  module CalendarBuilder
    
    def calendar_builder(type = :month, options = {}, &block)
      yield Calendar::Builder.for(type).new(options)
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