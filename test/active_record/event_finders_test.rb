require File.dirname(__FILE__) + '/../test_helper'

class EventFindersTest < Test::Unit::TestCase
  # fixtures :events

  class Event < ActiveRecord::Base
    event_finders
  end
  class Game < ActiveRecord::Base
    event_finders :begin_at => 'start_time', :end_at => 'end_time'
  end
  
  def test_upcoming
    Event.upcoming.each do |event|
      assert event.begin_at > Time.now
    end
  end
  
  def test_find_by_month
    events = Event.in_month(Date.today)
    assert !events.include?(events)
  end
  
  def test_in_date_range
    begin_at = 10.days.from_now
    end_at = 20.days.from_now
    
    Event.in_date_range(begin_at..end_at).each do |event|
      # * end is always after the beginning of the range
      assert event.end_at > begin_at
      #  Beginning is before the range and ends after the beginning of the range
      assert (event.begin_at < begin_at && event.end_at > begin_at) ||
      # OR
      # * Beginning is inside the range.
        (begin_at..end_at).include?(event.begin_at)
    end
  end
  
  def test_in_date_range_with_outliers
    # January 2008, starting the week on Monday, has Dec 30-31 and Feb 1-2 in view
    Event.expects(:in_date_range).with(Date.parse('2007-12-30')..Date.parse('2008-02-02'))
    Event.in_month_with_outliers(Date.parse('2008-01-01'))
  end
  
  def test_in_date_range_with_outliers_near_end_of_month
    # January 2008, starting the week on Monday, has Dec 30-31 and Feb 1-2 in view
    Event.expects(:in_date_range).with(Date.parse('2007-12-30')..Date.parse('2008-02-02'))
    Event.in_month_with_outliers(Date.parse('2008-01-28'))
  end
  
  def test_on_date
    assert_equal Event.in_date_range((3.days.ago..3.days.ago)), Event.on_date(3.days.ago)
  end
end