require File.dirname(__FILE__) + '/../test_helper'

class DayTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_next_except_single
    cal = Calendar::Builder::Day.new :date => Date.civil(2007, 3, 3), :except => :sunday
    # 2007/3/3 is a Saturday, next should skip Sunday
    assert_equal Date.civil(2007, 3, 5), cal.next.date
  end

  def test_next_except_multiple
    cal = Calendar::Builder::Day.new :date => Date.civil(2007, 3, 2), :except => [:saturday, :sunday]
    assert_equal Date.civil(2007, 3, 5), cal.next.date
  end
  
  def test_previous_except_single
    cal = Calendar::Builder::Day.new :date => Date.civil(2007, 3, 5), :except => :sunday
    assert_equal Date.civil(2007, 3, 3), cal.previous.date
  end

  def test_previous_except_single
    cal = Calendar::Builder::Day.new :date => Date.civil(2007, 3, 5), :except => [:saturday, :sunday]
    assert_equal Date.civil(2007, 3, 2), cal.previous.date
  end
  
end