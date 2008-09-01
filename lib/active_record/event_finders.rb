module CollectiveIdea
  module EventFinders
    
    def self.included(base)
      base.extend(SingletonMethods)
    end
    
    module SingletonMethods
      def event_finders(options = {})
        options = {
          :begin_at => 'begin_at',
          :end_at => 'end_at'
        }.merge(options)
        
        write_inheritable_attribute :event_finder_options, options
        class_inheritable_reader :event_finder_options
        
        include InstanceMethods
        include Helpers
        extend Helpers
        extend ClassMethods
        
        class_eval do

          # Find for a range of dates
          # We use the beginning of day for the first date and the end of day for the last date
          # so that we get the full range.
          # The event's
          # * end is always after the beginning of the range
          # * Beginning is before the range and ends after the beginning of the range
          # OR
          # * Beginning is inside the range.
          # MySQL treats BETWEEN() strangely with dates, so we don't use it.
          named_scope :in_date_range, lambda{|range|
            range ||= (Date.today..Date.today)
            {:conditions => ["
              #{quoted_table_name}.#{quoted_end_at_column_name} >= :begin_at AND (
                (#{quoted_table_name}.#{quoted_begin_at_column_name} <= :begin_at AND :begin_at <= #{quoted_table_name}.#{quoted_end_at_column_name}) 
                  OR (#{quoted_table_name}.#{quoted_begin_at_column_name} >= :begin_at AND :end_at >= #{quoted_table_name}.#{quoted_begin_at_column_name} )
              )", {
              :begin_at => range.first.beginning_of_day, 
              :end_at => range.last.end_of_day}]}
          }

          named_scope :upcoming, lambda{ {:conditions => ["#{quoted_table_name}.#{quoted_end_at_column_name} > ?", Time.now]} }
        end    
      end
    end
    
    module ClassMethods
      
      def on_date(date=Date.today)
        # we call date.to_date to ensure it is a Date (not a Time or CalendarBuilder::Proxy)
        in_date_range(date.to_date..date.to_date)
      end
      
      def for_month(date=Date.today)
        in_date_range(date.beginning_of_month..date.end_of_month)
      end
      
      def in_rolling_month(date=Date.today, number_of_weeks=4)
        beginning = date.beginning_of_week-1
        ending = (beginning + number_of_weeks.weeks).next_week.beginning_of_week-2
        in_date_range(beginning..ending)
      end
      
      # In a typical month calendar view, you'll have a couple days at the start and/or end of the month
      # that are from the next/previous month.  This will find those dates too.  
      # FIXME: Don't assume weeks start on Monday.
      def in_month_with_outliers(date=Date.today)
        in_date_range(date.beginning_of_month.beginning_of_week-1..date.end_of_month.next_week.beginning_of_week-2)
      end
    
    end
    
    module InstanceMethods
    end
    
    # Mixed into both classes and instances
    module Helpers
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