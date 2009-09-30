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

        include Helpers
        extend Helpers
        
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
        named_scope :in_date_range, lambda{|range|
          range ||= (Time.zone.today..Time.zone.today)
          {:conditions => ["
            #{quoted_table_name}.#{quoted_end_at_column_name} >= :begin_at AND (
              (#{quoted_table_name}.#{quoted_begin_at_column_name} <= :begin_at AND :begin_at <= #{quoted_table_name}.#{quoted_end_at_column_name}) 
                OR (#{quoted_table_name}.#{quoted_begin_at_column_name} >= :begin_at AND :end_at >= #{quoted_table_name}.#{quoted_begin_at_column_name} )
            )", {
            :begin_at => range.first.beginning_of_day.in_time_zone, 
            :end_at => range.last.end_of_day.in_time_zone}]}
        }

        named_scope :upcoming, lambda{ {:conditions => ["#{quoted_table_name}.#{quoted_end_at_column_name} > ?", Time.zone.now]} }

        # In a typical month calendar view, you'll have a couple days at the 
        # start and/or end of the month that are from the next/previous month.
        # This will find those dates too.
        # FIXME: Don't assume weeks start on Monday.
        scope_chain(:in_month_with_outliers) do |chain, *args|
          date = (args.shift || Time.zone.today).to_date
          start = date.beginning_of_month.beginning_of_week - 1
          stop = date.end_of_month.next_week.beginning_of_week - 2
          chain.in_date_range(start..stop)
        end
        
        scope_chain(:on_date) do |chain, *args|
          # we call date.to_date to ensure it is an instance of Date
          date = (args.shift || Time.zone.today).to_date
          chain.in_date_range(date..date)
        end
        
        scope_chain(:in_month) do |chain, *args|
          date = (args.shift || Time.zone.today).to_date
          chain.in_date_range(date.beginning_of_month..date.end_of_month)
        end
        
        scope_chain(:in_rolling_month) do |chain, *args|
          date = (args.shift || Time.zone.today).to_date
          number_of_weeks = (args.shift || 4)
          beginning = date.beginning_of_week - 1
          ending = (beginning + number_of_weeks.weeks).
            next_week.beginning_of_week - 2
          chain.in_date_range(beginning..ending)
        end
      end # event_finders
    private
      # Scope chain calls allow pseudo named_scope methods to behave as any
      # other named_scope would by doing some work and chaining the context of
      # the call to the link that was provided.
      #
      # Putting something in `scopes` is how named_scope works under the hood.
      # Associations ask the reflecting class if they have a scopes defined for
      # a method call the association does not respond to. If so, the 
      # association proxy will call the reflecting classes scope, and pass the 
      # context along. Passing the context along allows the scopes to chain 
      # eachother. It also makes this code ugly.
      def scope_chain(name, &block)
        scopes[name] = lambda { |chain, *args| yield(chain, *args) }
        meta_def(name) { |*args| scopes[name].call(self, *args) }
      end
    end # SingletonMethods

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