require File.dirname(__FILE__) + '/../../test_helper'

module Calendar
  module Builder
    class MonthTest < Test::Unit::TestCase
  
      def setup
        @cal = Month.new :date => Date.civil(2007, 2, 5)
      end
  
      def test_begin_on
        assert_equal Date.civil(2007, 1, 28), @cal.begin_on
      end
  
      def test_end_on
        assert_equal Date.civil(2007, 3, 3), @cal.end_on
      end
  
      def test_weeks_in_month
        assert_equal 4, Month.new(:date => Date.civil(2009, 2, 1)).weeks_in_month
        assert_equal 5, Month.new(:date => Date.civil(2007, 2, 1)).weeks_in_month
        assert_equal 6, Month.new(:date => Date.civil(2007, 9, 1)).weeks_in_month
      end
  
    end
  end
end