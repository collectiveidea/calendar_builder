
module CollectiveIdea
  module CalendarBuilder
    
    def calendar(options = {}, &block)
      cal = Calendar::Builder::Month.new(options)
      if block_given?
        yield(cal)
        concat cal.to_s, block.binding
      else
        cal.to_s
      end
    end
    
  end
end