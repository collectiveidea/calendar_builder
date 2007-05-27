module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Time #:nodoc:
      # Enables the use of time calculations within Time itself
      module Calculations

        # Returns a new Time representing the end of the day (23:59:59)
        def end_of_day
          change(:hour => 23, :min => 59, :sec => 59)
        end
      end
    end
  end
end