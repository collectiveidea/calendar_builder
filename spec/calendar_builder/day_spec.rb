require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CalendarBuilder::Day do
  it_should_behave_like 'All Calendars'
  
  it "should set type to :day" do
    CalendarBuilder::Day.new.type.should == :day
  end
  
  describe "next" do
    it "should skip a single excluded day" do
      # 2007/3/3 is a Saturday, next should skip Sunday
      cal = CalendarBuilder::Day.new :date => Date.new(2007, 3, 3), :except => :sunday
      cal.next.date.should == Date.new(2007, 3, 5)
    end
    
    it "should skip multiple excluded days" do
      cal = CalendarBuilder::Day.new :date => Date.new(2007, 3, 2), :except => [:saturday, :sunday]
      cal.next.date.should == Date.new(2007, 3, 5)
    end
  end
  
  describe "previous" do
    it "should skip a single excluded day" do
      cal = CalendarBuilder::Day.new :date => Date.new(2007, 3, 5), :except => :sunday
      cal.previous.date.should == Date.new(2007, 3, 3)
    end
    
    it "should skip multiple excluded days" do
      cal = CalendarBuilder::Day.new :date => Date.new(2007, 3, 5), :except => [:saturday, :sunday]
      cal.previous.date.should == Date.new(2007, 3, 2)
    end
  end
  
end
