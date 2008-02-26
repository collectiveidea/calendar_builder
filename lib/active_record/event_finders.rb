module CollectiveIdea
  module EventFinders
    
    def self.included(base)
      base.extend(SingletonMethods)
    end
    
    module SingletonMethods
      def calendar_finders(options = {})
        options = {
          :begin_at => 'begin_at',
          :end_at => 'end_at',
          :order => ''
        }.merge(options)
        
        write_inheritable_attribute :calendar_finder_options, options
        class_inheritable_reader :calendar_finder_options
        
        include InstanceMethods
        include Helpers
        extend Helpers
        extend ClassMethods
      end
    end
    
    module ClassMethods
      
      def find_for_date(date=Date.today, *args)
        # we call date.to_date to ensure it is a Date (not a Time or CalendarBuilder::Proxy)
        find_approved_for_date_range((date.to_date..date.to_date), *args)
      end

      # Find for a range of dates
      # The event's
      # * end is always after the beginning of the range
      # * Beginning is before the range and ends after the beginning of the range
      # OR
      # * Beginning is inside the range.
      def find_for_date_range(range=(Date.today..Date.today), *args)
        with_scope(:find => {:conditions => ["
          #{quoted_table_name}.#{quoted_end_at_column_name} >= :begin_at AND (
            (#{quoted_table_name}.#{quoted_begin_at_column_name} <= :begin_at AND :begin_at <= #{quoted_table_name}.#{quoted_end_at_column_name}) 
              OR (#{quoted_table_name}.#{quoted_begin_at_column_name} >= :begin_at AND :end_at >= #{quoted_table_name}.#{quoted_begin_at_column_name} )
          )", {
          :begin_at => range.first.beginning_of_day, 
          :end_at => range.last.end_of_day}]}) { find_scoped(*args) }
      end

      def find_for_month(date=Date.today, *args)
        # we call date.to_date to ensure it is a Date (not a Time or CalendarBuilder::Proxy)
        with_scope(:find => {:conditions => ["DATE_FORMAT(#{quoted_table_name}.#{quoted_begin_at_column_name}, \"%Y-%m\") = :date OR DATE_FORMAT(#{quoted_table_name}.#{quoted_end_at_column_name}, \"%Y-%m\") = :date", {:date => date.strftime("%Y-%m")}]}) do 
          find_scoped(*args)
        end
      end

      def find_upcoming(*args)
        with_scope(:find => {:conditions => ["#{quoted_table_name}.#{quoted_begin_at_column_name} > ? ", Time.now]}) { find_scoped(*args) }
      end

      # Common ordering for all the other finders
      def find_ordered(*args)
        with_scope(:find => {:order => calendar_finder_options[:order]}) do
          find(*args)
        end
      end
    
    end
    
    module InstanceMethods
    end
    
    # Mixed into both classes and instances
    module Helpers
      def begin_at_column_name
        calendar_finder_options[:begin_at]
      end
      
      def end_at_column_name
        calendar_finder_options[:end_at]
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