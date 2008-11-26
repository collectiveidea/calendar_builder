require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CalendarBuilder do
  
  describe "for" do
    it "should find day" do
      CalendarBuilder.for(:day).should == CalendarBuilder::Day
    end

    it "should find week" do
      CalendarBuilder.for(:week).should == CalendarBuilder::Week
    end

    it "should find month" do
      CalendarBuilder.for(:month).should == CalendarBuilder::Month
    end
    
    it "should find rolling month" do
      CalendarBuilder.for(:rolling_month).should == CalendarBuilder::RollingMonth
    end
  end
  
end