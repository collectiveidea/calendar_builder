require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CalendarBuilder::CoreExt::Time do
  
  describe "beginning_of_week" do
    it "should default to the previous monday" do
      Time.utc(2008, 11, 27).beginning_of_week.should == Time.utc(2008, 11, 24)
    end

    it "should be the previous sunday when given :sunday" do
      Time.utc(2008, 11, 27).beginning_of_week(:sunday).should == Time.utc(2008, 11, 23)
    end

    it "should be the previous monday when given :monday" do
      Time.utc(2008, 11, 27).beginning_of_week(:monday).should == Time.utc(2008, 11, 24)
    end

    it "should be the previous tuesday when given :tuesday" do
      Time.utc(2008, 11, 27).beginning_of_week(:tuesday).should == Time.utc(2008, 11, 25)
    end

    it "should be the previous Wednesday when given :wednesday" do
      Time.utc(2008, 11, 27).beginning_of_week(:wednesday).should == Time.utc(2008, 11, 26)
    end

    it "should be the previous Thursday when given :thursday" do
      Time.utc(2008, 11, 27).beginning_of_week(:thursday).should == Time.utc(2008, 11, 27)
    end

    it "should be the previous Friday when given :friday" do
      Time.utc(2008, 11, 27).beginning_of_week(:friday).should == Time.utc(2008, 11, 21)
    end

    it "should be the previous saturday when given :saturday" do
      Time.utc(2008, 11, 27).beginning_of_week(:saturday).should == Time.utc(2008, 11, 22)
    end
  end
  
  describe "end_of_week" do
    it "should default to the next sunday" do
      Time.utc(2008, 11, 27).end_of_week.should == Time.utc(2008, 11, 30).end_of_day
    end

    it "should be the next sunday when given :sunday" do
      Time.utc(2008, 11, 27).end_of_week(:sunday).should == Time.utc(2008, 11, 30).end_of_day
    end

    it "should be the next monday when given :monday" do
      Time.utc(2008, 11, 27).end_of_week(:monday).should == Time.utc(2008, 12, 1).end_of_day
    end

    it "should be the next tuesday when given :tuesday" do
      Time.utc(2008, 11, 27).end_of_week(:tuesday).should == Time.utc(2008, 12, 2).end_of_day
    end

    it "should be the next Wednesday when given :wednesday" do
      Time.utc(2008, 11, 27).end_of_week(:wednesday).should == Time.utc(2008, 12, 3).end_of_day
    end

    it "should be the next Thursday when given :thursday" do
      Time.utc(2008, 11, 27).end_of_week(:thursday).should == Time.utc(2008, 11, 27).end_of_day
    end

    it "should be the next Friday when given :friday" do
      Time.utc(2008, 11, 27).end_of_week(:friday).should == Time.utc(2008, 11, 28).end_of_day
    end

    it "should be the next saturday when given :saturday" do
      Time.utc(2008, 11, 27).end_of_week(:saturday).should == Time.utc(2008, 11, 29).end_of_day
    end
  end

end