require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CalendarBuilder::RollingMonth do
  it_should_behave_like 'All Calendars'
  
  it "should set type to :week" do
    CalendarBuilder::RollingMonth.new.type.should == :rolling_month
  end
  
end
