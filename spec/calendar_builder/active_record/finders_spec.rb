require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CalendarBuilder::ActiveRecord::Finders do
  class Event < ActiveRecord::Base
    event_finders
  end
  class Game < ActiveRecord::Base
    event_finders :begin_at => 'start_time', :end_at => 'end_time'
  end

  it "should include and extend Columns" do
    Event.should be_kind_of(CalendarBuilder::ActiveRecord::Finders::Columns)
    Event.new.should be_kind_of(CalendarBuilder::ActiveRecord::Finders::Columns)
  end
  
  it "should use begin_at by default" do
    Event.begin_at_column_name.should == 'begin_at'
  end

  it "should use end_at by default" do
    Event.end_at_column_name.should ==  'end_at'
  end

  it "should be able to override begin_at and end_at" do
    Game.begin_at_column_name.should == 'start_time'
    Game.end_at_column_name.should == 'end_time'
  end
  
  describe "overlapping" do
    it "should find events beginning during the range" do
      event = Event.create! :begin_at => Time.now, :end_at => 2.hours.from_now
      Event.overlapping((event.begin_at - 1)..(event.begin_at + 1)).should include(event)
    end
    
    it "should find events beginning at the same time as the start of the range" do
      event = Event.create! :begin_at => Time.now, :end_at => 1.hour.from_now
      Event.overlapping((event.begin_at)..(event.begin_at + 1)).should include(event)
    end

    it "should not find events beginning at the same time as the end of the range" do
      event = Event.create! :begin_at => Time.now, :end_at => 1.hour.from_now
      Event.overlapping((event.begin_at - 1)..(event.begin_at)).should_not include(event)
    end

    it "should not find events beginning after the end of the range" do
      event = Event.create! :begin_at => Time.now, :end_at => 1.hour.from_now
      Event.overlapping((event.begin_at - 2)..(event.begin_at - 1)).should_not include(event)
    end

    it "should not find events ending at the same time as the start of the range" do
      event = Event.create! :begin_at => 10.minutes.ago, :end_at => Time.now
      Event.overlapping((event.end_at)..(event.end_at + 1.hour)).should_not include(event)
    end

    it "should find events ending during the range" do
      event = Event.create! :begin_at => 10.minutes.ago, :end_at => Time.now
      Event.overlapping((event.end_at - 1)..(event.end_at + 1)).should include(event)
    end

    it "should not find events ending before the start of the range" do
      event = Event.create! :begin_at => 10.minutes.ago, :end_at => Time.now
      Event.overlapping((event.end_at + 1)..(event.end_at + 1.hour)).should_not include(event)
    end
    
    it "should include events beginning before the start of the range and ending after the end of the range" do
      event = Event.create! :begin_at => 10.minutes.ago, :end_at => 10.minutes.from_now
      Event.overlapping((event.begin_at + 1)..(event.end_at - 1)).should include(event)
    end
  end
  
  describe "upcoming" do
    it "should include events in the future" do
      event = Event.create! :begin_at => 1.hour.from_now, :end_at => 2.hours.from_now
      Event.upcoming.should include(event)
    end

    it "should not include events in the past" do
      event = Event.create! :begin_at => 1.hour.ago, :end_at => 1.second.ago
      Event.upcoming.should_not include(event)
    end

    it "should include events happing now" do
      event = Event.create! :begin_at => 1.hour.ago, :end_at => 10.seconds.from_now
      Event.upcoming.should include(event)
    end
  end
  
  describe "scheduled" do
    
    describe "with a date" do
      it "should find events from the beginning to the end of the day" do
        date = Date.today
        Event.should_receive(:overlapping).with(date.to_time.beginning_of_day..date.to_time.end_of_day).and_return('scope')
        Event.scheduled(date).should == 'scope'
      end
      
      it "should include events starting at beginning of day" do
        event = Event.create! :begin_at => Time.now.beginning_of_day, :end_at => (Time.now.beginning_of_day + 1.hour)
        Event.scheduled(event.begin_at.to_date).should include(event)
      end

      it "should include events ending at end of day" do
        event = Event.create! :begin_at => Time.now, :end_at => Time.now.end_of_day
        Event.scheduled(event.end_at.to_date).should include(event)
      end

      it "should not include events beginning after the givens date" do
        event = Event.create!(:begin_at => 1.week.from_now, :end_at => 1.week.from_now + 1.hour)
        Event.scheduled(event.begin_at.to_date - 1).should_not include(event)
      end

      it "should not include events ending before the given date" do
        event = Event.create!(:begin_at => 1.week.ago, :end_at => 1.week.ago + 1.hour)
        Event.scheduled(event.end_at.to_date + 1).should_not include(event)
      end
    end

    it "should find events for the date range of a calendar" do
      calendar = CalendarBuilder.for(:week).new(:date => Date.today)
      Event.should_receive(:overlapping).with(calendar.begin_at..calendar.end_at).and_return('scope')
      Event.scheduled(calendar).should == 'scope'
    end
    
    it "should find events for a given date range" do
      Event.should_receive(:overlapping).with(1..2).and_return('scope')
      Event.scheduled(1..2).should == 'scope'
    end
    
    it "should raise an argument error when other arguments are passed" do
      lambda { Event.scheduled(1) }.should raise_error(ArgumentError)
      lambda { Event.scheduled('a') }.should raise_error(ArgumentError)
    end
  end
  
end