require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CalendarBuilder::ActiveRecord::Validations do
  class Event < ActiveRecord::Base
    validates_chronological :begin_at, :end_at
  end
  
  describe "validates_chronological" do
    describe "when dates are chronological" do
      it "should be valid if  dates are chronological" do
        Event.new(:begin_at => Time.now, :end_at => 10.seconds.from_now).should be_valid
      end
    end
    
    describe "when dates are not chronological" do
      before do
        @event = Event.new(:begin_at => Time.now, :end_at => 10.seconds.ago)
      end

      it "should be invalid" do
        @event.should_not be_valid
      end
      
      it "should add an error on the attribute that is not chronological" do
        @event.valid?
        @event.errors.on(:end_at).should_not be_nil
      end
    end

    it "should be valid when attributes are nil" do
      Event.new.should be_valid
      Event.new(:begin_at => Time.now).should be_valid
      Event.new(:end_at => Time.now).should be_valid
    end
    
    describe "when allow_nil is false" do
      class Party < ActiveRecord::Base
        set_table_name 'events'
        validates_chronological :begin_at, :end_at, :allow_nil => false
      end
      
      it "should not be valid when attributes are nil" do
        Party.new.should_not be_valid
        Party.new(:begin_at => Time.now).should_not be_valid
        Party.new(:end_at => Time.now).should_not be_valid
      end

    end
  end

end