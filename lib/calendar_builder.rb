
module CollectiveIdea
  module CalendarBuilder
    
    def calendar(options = {}, &block)
      type = options.delete(:type) || :month
      cal = Calendar::Builder.const_get(type.to_s.camelize).new(options)
      if block_given?
        yield(cal)
        concat cal.to_s, block.binding
      else
        cal
      end
    end
    
    def calendar_for(events, options = {}, &block)
      event_begin_at = options.delete(:begin_at) || :begin_at
      grouped_events = events.group_by {|event| event.send(event_begin_at).to_date }

      type = options.delete(:type) || :month
      cal = Calendar::Builder.const_get(type.to_s.camelize).new(options)

      cal.each do |day|
        (grouped_events[day.date] || []).each do |event|
          yield event
        end
      end

      concat cal.to_s, block.binding
    end
    
  end
end