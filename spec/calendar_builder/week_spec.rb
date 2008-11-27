require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CalendarBuilder::Week do
  it_should_behave_like 'All Calendars'
  
  it "should set type to :week" do
    CalendarBuilder::Week.new.type.should == :week
  end
  
  describe "begin_on" do
    it "should default to sunday before given date" do
      week = CalendarBuilder::Week.new(:date => Date.new(2008, 11, 26))
      week.begin_on.should == Date.new(2008, 11, 23)
    end

    it "should be the monday before the given date when first_day_of_week is :monday" do
      week = CalendarBuilder::Week.new(:date => Date.new(2008, 11, 26), :first_day_of_week => :monday)
      week.begin_on.should == Date.new(2008, 11, 24)
    end
  end
  
  describe "end_on" do
    it "should be the last day of the week" do
      week = CalendarBuilder::Week.new(:date => Date.new(2007, 1, 26))
      week.end_on.should == Date.new(2007, 1, 27)
    end
    
  end
  
  describe "first_day_of_week" do
    it "should default to 0 for sunday" do
      CalendarBuilder::Week.new.first_day_of_week.should == 0
    end
    
    it "should be 1 when set to :monday" do
      week = CalendarBuilder::Week.new :first_day_of_week => :monday
      week.first_day_of_week.should == 1
    end
    
    it "can be set as an integer" do
      week = CalendarBuilder::Week.new :first_day_of_week => 2
      week.first_day_of_week.should == 2
    end
  end
  
  describe "days" do
    it "should be an array of all the days in the week" do
      week = CalendarBuilder::Week.new :date => Date.new(2007, 2, 1)
      week.days.should == (Date.new(2007, 1, 28)..Date.new(2007, 2, 3)).to_a
    end
    
    it "should start on monday if first day of week is monday" do
      week = CalendarBuilder::Week.new :date => Date.new(2007, 2, 1), :first_day_of_week => 1
      week.days.should == (Date.new(2007, 1, 29)..Date.new(2007, 2, 4)).to_a
    end
    
    it "should exlude single day specified in :except" do
      CalendarBuilder::Week.new(:except => :sunday).days.each do |day|
        day.wday.should_not == 0
      end
    end
    
    it "should exlude multiple days specified in :except" do
      CalendarBuilder::Week.new(:except => [:saturday, :sunday]).days.each do |day|
        [0, 6].should_not include(day.wday)
      end
    end
  end
    
end
