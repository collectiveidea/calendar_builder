require File.dirname(__FILE__) + '/../test_helper'

class WeekTest < Test::Unit::TestCase
  
  def setup
    @cal = Calendar::Builder::Week.new :date => Date.civil(2007, 2, 1)
  end
  
  def test_days_of_week
    cal = Calendar::Builder::Week.new
    assert_equal "Sunday", cal.days_of_week.first
    cal = Calendar::Builder::Week.new :first_day_of_week => 1
    assert_equal "Monday", cal.days_of_week.first
    cal = Calendar::Builder::Week.new :first_day_of_week => 4
    assert_equal "Thursday", cal.days_of_week.first
    
    cal = Calendar::Builder::Week.new :abbreviate_labels => true
    assert_equal "Sun", cal.days_of_week.first
  end
  
  def test_days_between
    assert_equal 4, @cal.send(:days_between, 0, 4)
    assert_equal 2, @cal.send(:days_between, 6, 1)
    assert_equal 0, @cal.send(:days_between, 6, 6)
  end
  
  def test_days_in_week
    assert_equal (Date.civil(2007, 1, 28)..Date.civil(2007, 2, 3)).to_a, @cal.days_in_week
  end
  
  def test_days_in_week_for_calendar_starting_on_monday
    cal = Calendar::Builder::Week.new :date => Date.civil(2007, 2, 1),
      :first_day_of_week => 1
    assert_equal (Date.civil(2007, 1, 29)..Date.civil(2007, 2, 4)).to_a, cal.days_in_week
  end
  
  def test_beginning_of_week
    assert_equal Date.civil(2007, 1, 21), @cal.beginning_of_week(Date.civil(2007, 1, 26))
  end
  
  def test_end_of_week
    expected = Date.civil(2007, 1, 27)
    actual = @cal.end_of_week(Date.civil(2007, 1, 26))
    assert_equal expected, actual, "expected #{expected.to_s} but was #{actual.to_s}"
  end
  
  def test_empty_days
    assert_not_nil @cal.days
    assert_kind_of Hash, @cal.days
  end
  
  
end