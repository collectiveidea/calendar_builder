require File.dirname(__FILE__) + '/test_helper'

class CalendarController < ActionController::Base
  def self.controller_name; "test"; end
  def self.controller_path; "test"; end
  
  def default_month_view
    render :inline => "<%= calendar %>"
  end
  
  def month
    render :template => 'month', :layout => false
  end
  
  # Re-raise errors caught by the controller.
  def rescue_action(e) raise e end
end
CalendarController.template_root = File.dirname(__FILE__) + "/fixtures"

class CalendarBuilderTest < Test::Unit::TestCase
  
  def setup
    @controller = CalendarController.new

    @controller.logger = Logger.new(nil)

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.host = "www.example.com"
  end
  
  def test_default_month
    get :default_month_view
    assert_calendar
  end
  
  def test_month
    get :month
    puts @response.body
    assert_calendar do
      assert_select "td" do
        assert_select "span.day", /\d/
      end
    end
  end
  
private
  
  def assert_calendar
    assert_select "table" do
      assert_select "thead" do
        assert_select "tr" do
          assert_select "th.month", 1
          assert_select "th.day", 7
        end
      end
      assert_select "tbody" do
        assert_select "tr", 4..6
        if block_given?
          yield
        else
          assert_select "td", /\d/
        end
      end
    end
  end

end
