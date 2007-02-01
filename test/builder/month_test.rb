require File.dirname(__FILE__) + '/../test_helper'

class MonthTest < Test::Unit::TestCase
  
  def setup
    @cal = Calendar::Builder::Month.new
  end
  
end