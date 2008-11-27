require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CalendarBuilder::Month do
  it_should_behave_like 'All Calendars'
  
  before do
    @month = CalendarBuilder::Month.new(:date => Date.new(2007, 2, 5))
  end
  
  it "should set type to :month" do
    CalendarBuilder::Month.new.type.should == :month
  end
  
  describe "begin_on" do
    it "should be the monday before the first day of the month" do
      @month.begin_on.should == Date.new(2007, 1, 28)
    end
  end
  
  describe "end_on" do
    it "should be the sunday after the last day of the month" do
      @month.end_on.should == Date.new(2007, 3, 3)
    end
  end
  
  describe "weeks_in_month" do
    it "should return the number of weeks in the current month" do
      CalendarBuilder::Month.new(:date => Date.new(2009, 2, 1)).weeks_in_month.should == 4
      CalendarBuilder::Month.new(:date => Date.new(2007, 2, 1)).weeks_in_month.should == 5
      CalendarBuilder::Month.new(:date => Date.new(2007, 9, 1)).weeks_in_month.should == 6
    end
  end

end
