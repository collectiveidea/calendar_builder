require File.dirname(__FILE__) + '/../../test_helper'

module Calendar
  module Builder
    class WeekTest < Test::Unit::TestCase
  
      def setup
        @cal = Week.new :date => Date.civil(2007, 2, 1)
      end
  
      def test_days_between
        assert_equal 4, @cal.send(:days_between, 0, 4)
        assert_equal 2, @cal.send(:days_between, 6, 1)
        assert_equal 0, @cal.send(:days_between, 6, 6)
      end
  
      def test_days_in_week
        assert_equal (Date.civil(2007, 1, 28)..Date.civil(2007, 2, 3)).to_a, @cal.days
      end
  
      def test_days_in_week_for_calendar_starting_on_monday
        cal = Week.new :date => Date.civil(2007, 2, 1),
          :first_day_of_week => 1
        assert_equal (Date.civil(2007, 1, 29)..Date.civil(2007, 2, 4)).to_a, cal.days
      end
  
      def test_default_first_day_of_week_is_sunday
        cal = Week.new :date => Date.civil(2007, 2, 1)
        assert_equal 0, cal.first_day_of_week
        assert_equal Date.civil(2007, 1, 28), cal.beginning_of_week
      end
  
      def test_first_day_of_week_as_symbol
        cal = Week.new :first_day_of_week => :monday,
          :date => Date.civil(2007, 2, 1)
        assert_equal 1, cal.first_day_of_week
        assert_equal Date.civil(2007, 1, 29), cal.beginning_of_week
      end
  
      def test_first_day_of_week_as_integer
        cal = Week.new :first_day_of_week => 2,
          :date => Date.civil(2007, 2, 1)
        assert_equal 2, cal.first_day_of_week
        assert_equal Date.civil(2007, 1, 30), cal.beginning_of_week
      end
  
      def test_beginning_of_week
        assert_equal Date.civil(2007, 1, 21), @cal.beginning_of_week(Date.civil(2007, 1, 26))
      end
  
      def test_end_of_week
        expected = Date.civil(2007, 1, 27)
        actual = @cal.end_of_week(Date.civil(2007, 1, 26))
        assert_equal expected, actual, "expected #{expected.to_s} but was #{actual.to_s}"
      end
  
      def test_except_single
        cal = Week.new :except => :sunday
        assert_equal 6, cal.days.size
        cal.days.each {|day| assert_not_equal 0, day.wday}
      end

      def test_except_multiple
        cal = Week.new :except => [:saturday, :sunday]
        assert_equal 5, cal.days.size
        cal.days.each {|day| assert ![0, 6].include?(day.wday) }
      end
  
    end
  end
end