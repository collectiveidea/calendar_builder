
shared_examples_for "All Calendars" do
  describe "initialize" do
    it "should use today as the default date" do
      CalendarBuilder::Day.new.date.should == Date.today
    end
  
    it "should convert the date as a string to a date" do
      CalendarBuilder::Day.new(:date => '2008-11-26').date.should == Date.new(2008, 11, 26)
    end
  
    it "should use today if date is set to nil" do
      CalendarBuilder::Day.new(:date => nil).date.should == Date.today
    end
  end
end

