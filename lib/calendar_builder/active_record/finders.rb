module CalendarBuilder
  module ActiveRecord
    module Finders
    
      def self.included(base)
        base.extend(SingletonMethods)
      end
    
      module SingletonMethods
        # FIXME: rename (something like #scheduled or #is_event??)
        def event_finders(options = {})
          options = {
            :begin_at => 'begin_at',
            :end_at => 'end_at'
          }.merge(options)
        
          write_inheritable_attribute :event_finder_options, options
          class_inheritable_reader :event_finder_options

          include Columns
          extend Columns
          extend ClassMethods
        
          # Find for a range of dates
          #
          # We use the beginning of day for the first date and the end of day for 
          # the last date so that we get the full range.
          #
          # The event's
          # * end is always after the beginning of the range
          # * Beginning is before the range and ends after the beginning of the 
          #   range
          # OR
          # * Beginning is inside the range.
          #
          # MySQL treats BETWEEN() strangely with dates, so we don't use it.
          named_scope :overlapping, lambda {|range| {
            :conditions => [
              "#{quoted_table_name}.#{quoted_begin_at_column_name} < :end_at
              AND #{quoted_table_name}.#{quoted_end_at_column_name} > :begin_at",
              {:begin_at => range.first, :end_at => range.last}
            ]
          }}

          named_scope :upcoming, lambda {{
            :conditions => ["#{quoted_table_name}.#{quoted_end_at_column_name} > ?", Time.now]
          }}
        end
      end # SingletonMethods

      module ClassMethods
        
        def scheduled(period)
          if period.respond_to?(:begin_at) && period.respond_to?(:end_at)
            overlapping period.begin_at..period.end_at
          elsif Date === period
            overlapping period.to_time.beginning_of_day..period.to_time.end_of_day
          elsif Range === period
            overlapping period
          elsif Hash === period
            calendar = CalendarBuilder.for(period[:for]).new(:date => period[:on])
            scheduled calendar
          else
            raise ArgumentError, 'Must respond to #begin_at and #end_at, or be a Date or Range'
          end
        end
        
      end

      # Mixed into both classes and instances
      module Columns
        def begin_at_column_name
          event_finder_options[:begin_at]
        end
      
        def end_at_column_name
          event_finder_options[:end_at]
        end
      
        def quoted_begin_at_column_name
          connection.quote_column_name(begin_at_column_name)
        end
      
        def quoted_end_at_column_name
          connection.quote_column_name(end_at_column_name)
        end
      end
    end
  end
end