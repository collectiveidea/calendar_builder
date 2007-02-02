require 'builder'

module Calendar
  module Builder
    class Base
      attr_accessor :options
      
      def initialize(options = {})
        @options = options
      end
      
    end
  end
end