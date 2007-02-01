require 'builder'

module Calendar
  module Builder
    class Base
      attr_accessor :options
      
      def initialize(options = {})
        @options = {
          :abbreviate_labels => false,
        }.merge(options)
      end
      
    end
  end
end